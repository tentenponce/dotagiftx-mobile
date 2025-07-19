import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/usecases/login_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/states/login_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState>
    with CubitErrorMixin<LoginState> {
  late final void Function() navigateToHome;

  final Logger _logger;
  final EnvironmentVariables _environmentVariables;
  final LoginUsecase _loginUsecase;

  LoginCubit(this._logger, this._environmentVariables, this._loginUsecase)
    : super(const LoginState());

  @override
  Logger get logger => _logger;

  String getLoginUrl() {
    return '${_environmentVariables.baseUrl}${ApiConstants.loginUrl}';
  }

  @override
  Future<void> init() async {}

  Future<void> login(String openid) async {
    emit(state.copyWith(loadingLogin: true));
    await cubitHandler(() => _loginUsecase(openid), (_) async {
      navigateToHome();
    });

    emit(state.copyWith(loadingLogin: false));
  }
}
