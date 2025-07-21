import 'dart:convert';

import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/login_usecase.dart';
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
  final SharedPreferenceStorage _sharedPreferenceStorage;

  ProfileCubit(
    this._logger,
    this._environmentVariables,
    this._loginUsecase,
    this._sharedPreferenceStorage,
  ) : super(const ProfileState());

  @override
  Logger get logger => _logger;

  String getLoginUrl() {
    return '${_environmentVariables.baseUrl}${ApiConstants.loginUrl}';
  }

  @override
  Future<void> init() async {
    // consider being reactive, setup a publisher in shared preferences every save of any key
    final user = await _sharedPreferenceStorage.getValue<String>(
      SharedPreferencesKeys.user,
    );
    if (user != null) {
      emit(
        state.copyWith(
          user: UserModel.fromJson(jsonDecode(user) as Map<String, dynamic>),
        ),
      );
    }
  }

  Future<void> login(String openid) async {
    emit(state.copyWith(loadingLogin: true));
    await cubitHandler(() => _loginUsecase(openid), (user) async {
      emit(state.copyWith(user: user));
      navigateToHome();
    });

    emit(state.copyWith(loadingLogin: false));
  }
}
