import 'dart:async';

import 'package:dotagiftx_mobile/domain/usecases/token_rotation_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppCubit extends BaseCubit<void> {
  final TokenRotationUsecase _tokenRotationUsecase;

  AppCubit(this._tokenRotationUsecase) : super(null);

  @override
  Future<void> init() async {
    unawaited(_tokenRotationUsecase.start());
  }
}
