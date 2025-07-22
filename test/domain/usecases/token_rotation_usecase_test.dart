import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/future_utils.dart';
import 'package:dotagiftx_mobile/core/utils/retry_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/usecases/refresh_token_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/token_rotation_usecase.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'token_rotation_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<KeychainStorage>(),
  MockSpec<SharedPreferenceStorage>(),
  MockSpec<DotagiftxRemoteConfig>(),
  MockSpec<RefreshTokenUsecase>(),
])
void main() {
  group(TokenRotationUsecaseImpl, () {
    late MockLogger mockLogger;
    late MockKeychainStorage mockKeychainStorage;
    late MockSharedPreferenceStorage mockSharedPreferenceStorage;
    late MockDotagiftxRemoteConfig mockDotagiftxRemoteConfig;
    late MockRefreshTokenUsecase mockRefreshTokenUsecase;
    late TokenRotationUsecaseImpl usecase;

    // Test data
    const testTokenRotationSeconds = 300; // 5 minutes

    setUp(() {
      mockLogger = MockLogger();
      mockKeychainStorage = MockKeychainStorage();
      mockSharedPreferenceStorage = MockSharedPreferenceStorage();
      mockDotagiftxRemoteConfig = MockDotagiftxRemoteConfig();
      mockRefreshTokenUsecase = MockRefreshTokenUsecase();
      usecase = TokenRotationUsecaseImpl(
        mockLogger,
        mockKeychainStorage,
        mockSharedPreferenceStorage,
        mockDotagiftxRemoteConfig,
        mockRefreshTokenUsecase,
        RetryUtilsImpl(FutureUtilsImpl()),
      );
    });

    test(
      'start should call refresh token thrice if time passed 3 times the interval',
      () async {
        when(
          mockDotagiftxRemoteConfig.getTokenRotationSeconds(),
        ).thenAnswer((_) => Future.value(testTokenRotationSeconds));

        fakeAsync((async) {
          usecase.start();

          async.elapse(const Duration(minutes: 15));

          const expectedNumberOfCalls = 3;

          /// add one extra call since refresh token is getting fetch before
          /// starting timer to reset validity properly
          verify(
            mockRefreshTokenUsecase.refresh(),
          ).called(expectedNumberOfCalls + 1);
        });
      },
    );

    test('should logout if refresh token returns unauthorized', () async {
      when(
        mockDotagiftxRemoteConfig.getTokenRotationSeconds(),
      ).thenAnswer((_) => Future.value(testTokenRotationSeconds));

      when(mockRefreshTokenUsecase.refresh()).thenAnswer(
        (_) => Future.error(
          UnauthorizedException(
            error: DioException(requestOptions: RequestOptions()),
          ),
        ),
      );

      fakeAsync((async) {
        usecase.start();

        async.elapse(const Duration(minutes: 15));

        verify(
          mockSharedPreferenceStorage.clear(SharedPreferencesKeys.user),
        ).called(3);
        verify(mockKeychainStorage.clearAll()).called(3);
      });
    });

    test(
      'should log error if refresh token fails but not unauthorized',
      () async {
        final mockException = Exception('Refresh token failed');
        when(
          mockDotagiftxRemoteConfig.getTokenRotationSeconds(),
        ).thenAnswer((_) => Future.value(testTokenRotationSeconds));

        when(
          mockRefreshTokenUsecase.refresh(),
        ).thenAnswer((_) => Future.error(mockException));

        fakeAsync((async) {
          usecase.start();

          async.elapse(const Duration(minutes: 15));

          verifyNever(
            mockSharedPreferenceStorage.clear(SharedPreferencesKeys.user),
          );
          verifyNever(mockKeychainStorage.clearAll());
          verify(
            mockLogger.log(
              LogLevel.error,
              'error refreshing token: $mockException',
              mockException,
            ),
          ).called(3);
        });
      },
    );
  });
}
