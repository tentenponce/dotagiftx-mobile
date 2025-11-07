import 'dart:async';

import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/local/listen_local_storage.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_user_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/login_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/logout_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/states/profile_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState>
    with CubitErrorMixin<ProfileState> {
  late final void Function() loginSuccess;
  late final void Function() logoutSuccess;

  final Logger _logger;
  final EnvironmentVariables _environmentVariables;
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final GetUserUsecase _getUserUsecase;
  final ListenLocalStorage _listenLocalStorage;

  ProfileCubit(
    this._logger,
    this._environmentVariables,
    this._loginUsecase,
    this._logoutUsecase,
    this._getUserUsecase,
    this._listenLocalStorage,
  ) : super(const ProfileState());

  @override
  Logger get logger => _logger;

  String getLoginUrl() {
    return '${_environmentVariables.baseUrl}${ApiConstants.loginUrl}';
  }

  @override
  Future<void> init() async {
    emit(state.copyWith(isLoadingUser: true));
    _listenLocalStorage.listenUser().listen(
      (user) {
        emit(state.copyWith(user: user, isLoadingUser: false));
      },
      // ignore: inference_failure_on_untyped_parameter
      onError: (e, st) {
        _logger.log(
          LogLevel.error,
          'Error getting user',
          e,
          st is StackTrace ? st : StackTrace.current,
        );
        emit(state.copyWith(user: null, isLoadingUser: false));
      },
    );
  }

  void initProfileLoggedInView() {
    unawaited(
      cubitHandler(_getUserUsecase.call, (user) async {
        emit(state.copyWith(user: user));
      }),
    );
  }

  Future<void> login(String openid) async {
    emit(state.copyWith(loadingLogin: true));
    await cubitHandler(() => _loginUsecase(openid), (user) async {
      emit(state.copyWith(user: user));
      loginSuccess();
    });

    emit(state.copyWith(loadingLogin: false));
  }

  Future<void> logout() async {
    emit(state.copyWith(loadingLogout: true));
    await cubitHandler(_logoutUsecase.call, (_) async {
      emit(state.copyWith(user: null));
      logoutSuccess();
    });

    emit(state.copyWith(loadingLogout: false));
  }
}
