import 'dart:convert';

import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class LoginUsecase {
  Future<UserModel> call(String openid);
}

@LazySingleton(as: LoginUsecase)
class LoginUsecaseImpl implements LoginUsecase {
  final DotagiftxUnauthApi _dotagiftxUnauthApi;
  final DotagiftxAuthApi _dotagiftxApi;
  final KeychainStorage _keychainStorage;
  final SharedPreferenceStorage _sharedPreferenceStorage;

  LoginUsecaseImpl(
    this._dotagiftxUnauthApi,
    this._dotagiftxApi,
    this._keychainStorage,
    this._sharedPreferenceStorage,
  );

  @override
  Future<UserModel> call(String openid) async {
    final authResponse = await _dotagiftxUnauthApi.loginSteam(openid);

    // consider this to be unawaited if more processes are added, or if
    // one of the process takes a long time to complete
    await Future.wait([
      _keychainStorage.add(KeychainKeys.token, authResponse.token),
      _keychainStorage.add(
        KeychainKeys.refreshToken,
        authResponse.refreshToken,
      ),
      _keychainStorage.add(KeychainKeys.expiresAt, authResponse.expiresAt),
      _keychainStorage.add(KeychainKeys.userId, authResponse.userId),
      _keychainStorage.add(KeychainKeys.steamId, authResponse.steamId),
    ]);

    final userResponse = await _dotagiftxApi.getUser();

    await _sharedPreferenceStorage.setValue(
      SharedPreferencesKeys.user,
      jsonEncode(userResponse.toJson()),
    );

    return userResponse;
  }
}
