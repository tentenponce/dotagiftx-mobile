import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/future_utils.dart';
import 'package:dotagiftx_mobile/core/utils/retry_utils.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/requests/refresh_token_request.dart';
import 'package:dotagiftx_mobile/data/responses/refresh_token_response.dart';
import 'package:dotagiftx_mobile/domain/usecases/refresh_token_usecase.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'refresh_token_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<KeychainStorage>(),
  MockSpec<DotagiftxUnauthApi>(),
])
void main() {
  group(RefreshTokenUsecaseImpl, () {
    late MockLogger mockLogger;
    late MockKeychainStorage mockKeychainStorage;
    late MockDotagiftxUnauthApi mockDotagiftxUnauthApi;
    late RefreshTokenUsecaseImpl usecase;

    // Test data
    const testRefreshToken = 'test-refresh-token-12345';
    const testNewToken = 'new-access-token-67890';
    const testNewExpiresAt = '2024-12-31T23:59:59Z';

    const testRefreshTokenResponse = RefreshTokenResponse(
      token: testNewToken,
      expiresAt: testNewExpiresAt,
    );

    setUp(() {
      mockLogger = MockLogger();
      mockKeychainStorage = MockKeychainStorage();
      mockDotagiftxUnauthApi = MockDotagiftxUnauthApi();
      usecase = RefreshTokenUsecaseImpl(
        mockLogger,
        mockKeychainStorage,
        mockDotagiftxUnauthApi,
        RetryUtilsImpl(FutureUtilsImpl()),
      );
    });

    group('refresh', () {
      test('should return null when refresh token is null', () async {
        // Arrange
        when(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).thenAnswer((_) async => null);

        // Act
        final result = await usecase.refresh();

        // Assert
        expect(result, isNull);
        verify(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).called(1);
      });

      test('should return null when refresh token is empty', () async {
        // Arrange
        when(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).thenAnswer((_) async => '');

        // Act
        final result = await usecase.refresh();

        // Assert
        expect(result, isNull);
        verify(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).called(1);
      });

      test('should refresh token successfully', () async {
        // Arrange
        when(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).thenAnswer((_) async => testRefreshToken);
        when(
          mockDotagiftxUnauthApi.refreshToken(any),
        ).thenAnswer((_) async => testRefreshTokenResponse);
        when(mockKeychainStorage.add(any, any)).thenAnswer((_) async => true);

        // Act
        final result = await usecase.refresh();

        // Assert
        expect(result, equals(testNewToken));

        verify(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).called(1);
        verify(
          mockDotagiftxUnauthApi.refreshToken(
            const RefreshTokenRequest(refreshToken: testRefreshToken),
          ),
        ).called(1);
        verify(
          mockKeychainStorage.add(KeychainKeys.token, testNewToken),
        ).called(1);
        verify(
          mockKeychainStorage.add(KeychainKeys.expiresAt, testNewExpiresAt),
        ).called(1);
      });

      test('should use cached result on subsequent calls', () async {
        // Arrange
        when(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).thenAnswer((_) async => testRefreshToken);
        when(
          mockDotagiftxUnauthApi.refreshToken(any),
        ).thenAnswer((_) async => testRefreshTokenResponse);
        when(mockKeychainStorage.add(any, any)).thenAnswer((_) async => true);

        // Act
        fakeAsync((async) {
          String? result1;
          usecase.refresh().then((value) {
            result1 = value;
          });

          String? result2;
          usecase.refresh().then((value) {
            result2 = value;
          });

          String? result3;
          usecase.refresh().then((value) {
            result3 = value;
          });

          async.elapse(const Duration(seconds: 1));
          async.elapse(const Duration(seconds: 1));

          // Assert
          expect(result1, equals(testNewToken));
          expect(result2, equals(result1));
          expect(result3, equals(result1));

          // API should only be called once due to caching
          verify(mockDotagiftxUnauthApi.refreshToken(any)).called(1);
        });
      });

      test('should throw exception when refresh token API fails', () async {
        // Arrange
        when(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).thenAnswer((_) async => testRefreshToken);
        when(
          mockDotagiftxUnauthApi.refreshToken(any),
        ).thenThrow(Exception('Refresh failed'));

        // Act & Assert
        await expectLater(() => usecase.refresh(), throwsException);

        verify(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).called(1);
        verifyNever(mockKeychainStorage.add(any, any));
      });

      test('should throw exception when token storage fails', () async {
        // Arrange
        when(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).thenAnswer((_) async => testRefreshToken);
        when(
          mockDotagiftxUnauthApi.refreshToken(any),
        ).thenAnswer((_) async => testRefreshTokenResponse);
        when(
          mockKeychainStorage.add(KeychainKeys.token, testNewToken),
        ).thenThrow(Exception('Storage failed'));

        // Act & Assert
        await expectLater(() => usecase.refresh(), throwsException);

        verify(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).called(1);
        verify(mockDotagiftxUnauthApi.refreshToken(any)).called(1);
        verify(
          mockKeychainStorage.add(KeychainKeys.token, testNewToken),
        ).called(1);
      });
    });
  });
}
