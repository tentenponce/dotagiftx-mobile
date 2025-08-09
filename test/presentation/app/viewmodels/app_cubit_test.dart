import 'package:dotagiftx_mobile/domain/usecases/token_rotation_usecase.dart';
import 'package:dotagiftx_mobile/presentation/app/viewmodels/app_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TokenRotationUsecase>()])
void main() {
  group(AppCubit, () {
    late MockTokenRotationUsecase mockTokenRotationUsecase;

    setUp(() {
      mockTokenRotationUsecase = MockTokenRotationUsecase();
    });

    AppCubit createUnitToTest() {
      return AppCubit(mockTokenRotationUsecase);
    }

    test('init should start token rotation', () async {
      createUnitToTest();

      verify(mockTokenRotationUsecase.start()).called(1);
    });
  });
}
