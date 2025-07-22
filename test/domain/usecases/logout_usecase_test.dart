import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/data/requests/revoke_token_request.dart';
import 'package:dotagiftx_mobile/domain/usecases/logout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<DotagiftxUnauthApi>(),
  MockSpec<KeychainStorage>(),
  MockSpec<SharedPreferenceStorage>(),
])
void main() {
  group(LogoutUsecaseImpl, () {
    late MockLogger mockLogger;
    late MockDotagiftxUnauthApi mockDotagiftxUnauthApi;
    late MockKeychainStorage mockKeychainStorage;
    late MockSharedPreferenceStorage mockSharedPreferenceStorage;
    late LogoutUsecaseImpl usecase;

    // Test data
    const testRefreshToken = 'test-refresh-token-12345';

    setUp(() {
      mockLogger = MockLogger();
      mockDotagiftxUnauthApi = MockDotagiftxUnauthApi();
      mockKeychainStorage = MockKeychainStorage();
      mockSharedPreferenceStorage = MockSharedPreferenceStorage();
      usecase = LogoutUsecaseImpl(
        mockLogger,
        mockDotagiftxUnauthApi,
        mockKeychainStorage,
        mockSharedPreferenceStorage,
      );
    });

    group('call', () {
      test(
        'should complete logout flow successfully with refresh token',
        () async {
          // Arrange
          when(
            mockKeychainStorage.getValue(KeychainKeys.refreshToken),
          ).thenAnswer((_) async => testRefreshToken);
          when(
            mockDotagiftxUnauthApi.revokeToken(any),
          ).thenAnswer((_) async {});
          when(
            mockSharedPreferenceStorage.clear(any),
          ).thenAnswer((_) async => true);
          when(mockKeychainStorage.clearAll()).thenAnswer((_) async {
            return;
          });

          // Act
          await usecase.call();

          // Assert
          verify(
            mockKeychainStorage.getValue(KeychainKeys.refreshToken),
          ).called(1);
          verify(
            mockDotagiftxUnauthApi.revokeToken(
              const RevokeTokenRequest(refreshToken: testRefreshToken),
            ),
          ).called(1);
          verify(
            mockSharedPreferenceStorage.clear(SharedPreferencesKeys.user),
          ).called(1);
          verify(mockKeychainStorage.clearAll()).called(1);
        },
      );

      test(
        'should complete logout flow successfully without refresh token',
        () async {
          // Arrange
          when(
            mockKeychainStorage.getValue(KeychainKeys.refreshToken),
          ).thenAnswer((_) async => null);
          when(mockDotagiftxUnauthApi.revokeToken(any)).thenAnswer((_) async {
            return;
          });
          when(
            mockSharedPreferenceStorage.clear(any),
          ).thenAnswer((_) async => true);
          when(mockKeychainStorage.clearAll()).thenAnswer((_) async {
            return;
          });

          // Act
          await usecase.call();

          // Assert
          verify(
            mockKeychainStorage.getValue(KeychainKeys.refreshToken),
          ).called(1);
          verify(
            mockDotagiftxUnauthApi.revokeToken(
              const RevokeTokenRequest(refreshToken: ''),
            ),
          ).called(1);
          verify(
            mockSharedPreferenceStorage.clear(SharedPreferencesKeys.user),
          ).called(1);
          verify(mockKeychainStorage.clearAll()).called(1);
        },
      );

      test(
        'should complete logout flow even when revoke token API fails',
        () async {
          // Arrange
          when(
            mockKeychainStorage.getValue(KeychainKeys.refreshToken),
          ).thenAnswer((_) async => testRefreshToken);
          when(
            mockDotagiftxUnauthApi.revokeToken(any),
          ).thenAnswer((_) => Future.error(Exception('Revoke failed')));
          when(
            mockSharedPreferenceStorage.clear(any),
          ).thenAnswer((_) async => true);
          when(mockKeychainStorage.clearAll()).thenAnswer((_) async {
            return;
          });

          // Act - should not throw because revoke token is unawaited
          await usecase.call();

          // Assert - storage clearing should still happen
          verify(
            mockKeychainStorage.getValue(KeychainKeys.refreshToken),
          ).called(1);
          verify(
            mockSharedPreferenceStorage.clear(SharedPreferencesKeys.user),
          ).called(1);
          verify(mockKeychainStorage.clearAll()).called(1);
        },
      );

      test(
        'should throw exception when shared preferences clear fails',
        () async {
          // Arrange
          when(
            mockKeychainStorage.getValue(KeychainKeys.refreshToken),
          ).thenAnswer((_) async => testRefreshToken);
          when(mockDotagiftxUnauthApi.revokeToken(any)).thenAnswer((_) async {
            return;
          });
          when(
            mockSharedPreferenceStorage.clear(SharedPreferencesKeys.user),
          ).thenThrow(Exception('Clear preferences failed'));
          when(mockKeychainStorage.clearAll()).thenAnswer((_) async {
            return;
          });

          // Act & Assert
          expect(() => usecase.call(), throwsException);
        },
      );

      test('should throw exception when keychain clear fails', () async {
        // Arrange
        when(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).thenAnswer((_) async => testRefreshToken);
        when(mockDotagiftxUnauthApi.revokeToken(any)).thenAnswer((_) async {
          return;
        });
        when(
          mockSharedPreferenceStorage.clear(any),
        ).thenAnswer((_) async => true);
        when(
          mockKeychainStorage.clearAll(),
        ).thenThrow(Exception('Clear keychain failed'));

        // Act & Assert
        await expectLater(() => usecase.call(), throwsException);

        verify(
          mockKeychainStorage.getValue(KeychainKeys.refreshToken),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.clear(SharedPreferencesKeys.user),
        ).called(1);
        verify(mockKeychainStorage.clearAll()).called(1);
      });
    });
  });
}
