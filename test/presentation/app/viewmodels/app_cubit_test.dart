import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/models/theme_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/token_rotation_usecase.dart';
import 'package:dotagiftx_mobile/presentation/app/viewmodels/app_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TokenRotationUsecase>(),
  MockSpec<DotagiftxRemoteConfig>(),
])
void main() {
  group(AppCubit, () {
    late MockTokenRotationUsecase mockTokenRotationUsecase;
    late MockDotagiftxRemoteConfig mockDotagiftxRemoteConfig;

    const testTheme = ThemeModel(
      seedColor: 'test_seed_color',
      brightness: 'test_brightness',
    );

    setUp(() async {
      mockTokenRotationUsecase = MockTokenRotationUsecase();
      mockDotagiftxRemoteConfig = MockDotagiftxRemoteConfig();

      when(
        mockDotagiftxRemoteConfig.getTheme(),
      ).thenAnswer((_) async => testTheme);
    });

    AppCubit createUnitToTest() {
      return AppCubit(mockTokenRotationUsecase, mockDotagiftxRemoteConfig);
    }

    test('init should start token rotation', () async {
      createUnitToTest();

      verify(mockTokenRotationUsecase.start()).called(1);
    });

    test('init should get theme', () async {
      createUnitToTest();

      verify(mockDotagiftxRemoteConfig.getTheme()).called(1);
    });
  });
}
