import 'dart:async';

import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/usecases/token_rotation_usecase.dart';
import 'package:dotagiftx_mobile/presentation/app/models/app_state.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppCubit extends BaseCubit<AppState> {
  final TokenRotationUsecase _tokenRotationUsecase;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;

  AppCubit(this._tokenRotationUsecase, this._dotagiftxRemoteConfig)
    : super(const AppState());

  @override
  Future<void> init() async {
    unawaited(_tokenRotationUsecase.start());
    unawaited(_getTheme());
  }

  Future<void> _getTheme() async {
    final theme = await _dotagiftxRemoteConfig.getTheme();

    emit(
      state.copyWith(seedColor: theme.seedColor, brightness: theme.brightness),
    );
  }
}
