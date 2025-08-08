import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/presentation/core/viewmodels/dotagiftx_image_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dotagiftx_image_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<DotagiftxRemoteConfig>(),
  MockSpec<EnvironmentVariables>(),
])
void main() {
  group(DotagiftxImageCubit, () {
    late MockLogger mockLogger;
    late MockDotagiftxRemoteConfig mockDotagiftxRemoteConfig;
    late MockEnvironmentVariables mockEnvironmentVariables;

    // Test data
    const testImageBaseUrl = 'https://test.example.com/images/';
    const testBaseUrl = 'https://test.example.com';
    const emptyImageBaseUrl = '';

    setUp(() {
      mockLogger = MockLogger();
      mockDotagiftxRemoteConfig = MockDotagiftxRemoteConfig();
      mockEnvironmentVariables = MockEnvironmentVariables();

      when(mockEnvironmentVariables.baseUrl).thenReturn(testBaseUrl);
    });

    DotagiftxImageCubit createUnitToTest() {
      return DotagiftxImageCubit(
        mockLogger,
        mockDotagiftxRemoteConfig,
        mockEnvironmentVariables,
      );
    }

    group('init', () {
      test('should load image base URL successfully on construction', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getDotagiftxImageBaseUrl(),
        ).thenAnswer((_) async => testImageBaseUrl);

        fakeAsync((async) {
          // Act
          final imageUrlCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockDotagiftxRemoteConfig.getDotagiftxImageBaseUrl(),
          ).called(1);
          expect(imageUrlCubit.state, equals(testImageBaseUrl));
        });
      });

      test(
        'should use default URL when remote config returns empty string',
        () async {
          // Arrange
          when(
            mockDotagiftxRemoteConfig.getDotagiftxImageBaseUrl(),
          ).thenAnswer((_) async => emptyImageBaseUrl);

          fakeAsync((async) {
            // Act
            final imageUrlCubit = createUnitToTest();

            async.elapse(Duration.zero);

            // Assert
            verify(
              mockDotagiftxRemoteConfig.getDotagiftxImageBaseUrl(),
            ).called(1);
            expect(
              imageUrlCubit.state,
              equals(
                '$testBaseUrl${RemoteConfigConstants.defaultDotagiftxImageEndpoint}',
              ),
            );
          });
        },
      );

      test('should handle error when loading image base URL', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getDotagiftxImageBaseUrl(),
        ).thenThrow(Exception('Failed to load image base URL'));

        fakeAsync((async) {
          // Act
          final imageUrlCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockDotagiftxRemoteConfig.getDotagiftxImageBaseUrl(),
          ).called(1);
          expect(
            imageUrlCubit.state,
            equals(
              '$testBaseUrl${RemoteConfigConstants.defaultDotagiftxImageEndpoint}',
            ),
          );
        });
      });
    });

    group('complex scenarios', () {
      test('should handle whitespace-only URL as empty', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getDotagiftxImageBaseUrl(),
        ).thenAnswer((_) async => '   ');

        fakeAsync((async) {
          // Act
          final imageUrlCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockDotagiftxRemoteConfig.getDotagiftxImageBaseUrl(),
          ).called(1);
          expect(
            imageUrlCubit.state,
            equals(
              '$testBaseUrl${RemoteConfigConstants.defaultDotagiftxImageEndpoint}',
            ),
          );
        });
      });
    });
  });
}
