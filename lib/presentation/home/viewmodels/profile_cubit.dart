import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/local/listen_local_storage.dart';
import 'package:dotagiftx_mobile/domain/usecases/login_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/logout_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/states/profile_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState>
    with CubitErrorMixin<ProfileState> {
  late final void Function() navigateToHome;

  final Logger _logger;
  final EnvironmentVariables _environmentVariables;
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final ListenLocalStorage _listenLocalStorage;

  ProfileCubit(
    this._logger,
    this._environmentVariables,
    this._loginUsecase,
    this._logoutUsecase,
    this._listenLocalStorage,
  ) : super(const ProfileState());

  @override
  Logger get logger => _logger;

  String getLoginUrl() {
    return '${_environmentVariables.baseUrl}${ApiConstants.loginUrl}';
  }

  @override
  Future<void> init() async {
    _listenLocalStorage.listenUser().listen((user) {
      emit(state.copyWith(user: user));
    });
  }

  Future<void> login(String openid) async {
    emit(state.copyWith(loadingLogin: true));
    await cubitHandler(() => _loginUsecase(openid), (user) async {
      emit(state.copyWith(user: user));
      navigateToHome();
    });

    emit(state.copyWith(loadingLogin: false));
  }

  Future<void> logout() async {
    emit(state.copyWith(loadingLogout: true));
    await cubitHandler(_logoutUsecase.call, (_) async {
      emit(state.copyWith(user: null));
      navigateToHome();
    });

    emit(state.copyWith(loadingLogout: false));
  }
}
