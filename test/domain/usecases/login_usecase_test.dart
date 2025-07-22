import 'dart:convert';

import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/data/responses/login_response.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DotagiftxUnauthApi>(),
  MockSpec<DotagiftxAuthApi>(),
  MockSpec<KeychainStorage>(),
  MockSpec<SharedPreferenceStorage>(),
])
void main() {
  group(LoginUsecaseImpl, () {
    late MockDotagiftxUnauthApi mockDotagiftxUnauthApi;
    late MockDotagiftxAuthApi mockDotagiftxAuthApi;
    late MockKeychainStorage mockKeychainStorage;
    late MockSharedPreferenceStorage mockSharedPreferenceStorage;
    late LoginUsecaseImpl usecase;

    // Test data
    const testOpenId = 'test-openid-12345';
    const testToken = 'test-access-token';
    const testRefreshToken = 'test-refresh-token';
    const testExpiresAt = '2024-12-31T23:59:59Z';
    const testUserId = 'user-123';
    const testSteamId = 'steam-456';

    const testLoginResponse = LoginResponse(
      token: testToken,
      refreshToken: testRefreshToken,
      expiresAt: testExpiresAt,
      userId: testUserId,
      steamId: testSteamId,
    );

    const testUserModel = UserModel(
      name: 'Test User',
      url: 'https://steamcommunity.com/profiles/12345',
      avatar: 'https://example.com/avatar.png',
      createdAt: '2024-01-01T00:00:00Z',
      marketStats: MarketStats(live: 5, reserved: 2, sold: 10, bidCompleted: 3),
      subscription: 1,
      subscribedAt: '2024-01-01T00:00:00Z',
    );

    setUp(() {
      mockDotagiftxUnauthApi = MockDotagiftxUnauthApi();
      mockDotagiftxAuthApi = MockDotagiftxAuthApi();
      mockKeychainStorage = MockKeychainStorage();
      mockSharedPreferenceStorage = MockSharedPreferenceStorage();
      usecase = LoginUsecaseImpl(
        mockDotagiftxUnauthApi,
        mockDotagiftxAuthApi,
        mockKeychainStorage,
        mockSharedPreferenceStorage,
      );
    });

    group('call', () {
      test('should complete login flow successfully', () async {
        // Arrange
        when(
          mockDotagiftxUnauthApi.loginSteam(testOpenId),
        ).thenAnswer((_) async => testLoginResponse);
        when(
          mockDotagiftxAuthApi.getUser(),
        ).thenAnswer((_) async => testUserModel);
        when(mockKeychainStorage.add(any, any)).thenAnswer((_) async => true);
        when(
          mockSharedPreferenceStorage.setValue(any, any),
        ).thenAnswer((_) async => true);

        // Act
        final result = await usecase.call(testOpenId);

        // Assert
        expect(result, equals(testUserModel));

        // Verify login API call
        verify(mockDotagiftxUnauthApi.loginSteam(testOpenId)).called(1);

        // Verify token is stored first
        verify(
          mockKeychainStorage.add(KeychainKeys.token, testToken),
        ).called(1);

        // Verify user API call
        verify(mockDotagiftxAuthApi.getUser()).called(1);

        // Verify other tokens are stored (these can be unawaited)
        verify(
          mockKeychainStorage.add(KeychainKeys.refreshToken, testRefreshToken),
        ).called(1);
        verify(
          mockKeychainStorage.add(KeychainKeys.expiresAt, testExpiresAt),
        ).called(1);
        verify(
          mockKeychainStorage.add(KeychainKeys.userId, testUserId),
        ).called(1);
        verify(
          mockKeychainStorage.add(KeychainKeys.steamId, testSteamId),
        ).called(1);

        // Verify user is stored in shared preferences
        verify(
          mockSharedPreferenceStorage.setValue(
            SharedPreferencesKeys.user,
            jsonEncode(testUserModel.toJson()),
          ),
        ).called(1);
      });

      test('should throw exception when login API fails', () async {
        // Arrange
        when(
          mockDotagiftxUnauthApi.loginSteam(testOpenId),
        ).thenThrow(Exception('Login failed'));

        // Act & Assert
        expect(() => usecase.call(testOpenId), throwsException);

        verify(mockDotagiftxUnauthApi.loginSteam(testOpenId)).called(1);
        verifyNever(mockKeychainStorage.add(any, any));
        verifyNever(mockDotagiftxAuthApi.getUser());
        verifyNever(mockSharedPreferenceStorage.setValue(any, any));
      });

      test('should throw exception when token storage fails', () async {
        // Arrange
        when(
          mockDotagiftxUnauthApi.loginSteam(testOpenId),
        ).thenAnswer((_) async => testLoginResponse);
        when(
          mockKeychainStorage.add(KeychainKeys.token, testToken),
        ).thenThrow(Exception('Storage failed'));

        // Act & Assert
        await expectLater(() => usecase.call(testOpenId), throwsException);

        verify(mockDotagiftxUnauthApi.loginSteam(testOpenId)).called(1);
        verify(
          mockKeychainStorage.add(KeychainKeys.token, testToken),
        ).called(1);
        verifyNever(mockDotagiftxAuthApi.getUser());
      });

      test('should throw exception when get user API fails', () async {
        // Arrange
        when(
          mockDotagiftxUnauthApi.loginSteam(testOpenId),
        ).thenAnswer((_) async => testLoginResponse);
        when(mockKeychainStorage.add(any, any)).thenAnswer((_) async {
          return;
        });
        when(
          mockDotagiftxAuthApi.getUser(),
        ).thenThrow(Exception('Get user failed'));

        // Act & Assert
        await expectLater(() => usecase.call(testOpenId), throwsException);

        verify(mockDotagiftxUnauthApi.loginSteam(testOpenId)).called(1);
        verify(
          mockKeychainStorage.add(KeychainKeys.token, testToken),
        ).called(1);
        verify(mockDotagiftxAuthApi.getUser()).called(1);
      });
    });
  });
}
