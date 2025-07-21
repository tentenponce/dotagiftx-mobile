import 'dart:convert';

import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
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
  final DotagiftxApi _dotagiftxApi;
  final KeychainStorage _keychainStorage;
  final SharedPreferenceStorage _sharedPreferenceStorage;

  LoginUsecaseImpl(
    this._dotagiftxApi,
    this._keychainStorage,
    this._sharedPreferenceStorage,
  );

  @override
  Future<UserModel> call(String openid) async {
    final response = await _dotagiftxApi.loginSteam(openid);
    final userResponse = await _dotagiftxApi.getUser(response.steamId);

    // consider this to be unawaited if more processes are added, or if
    // one of the process takes a long time to complete
    await Future.wait([
      _sharedPreferenceStorage.setValue(
        SharedPreferencesKeys.user,
        jsonEncode(userResponse.toJson()),
      ),
      _keychainStorage.add(KeychainKeys.token, response.token),
      _keychainStorage.add(KeychainKeys.refreshToken, response.refreshToken),
      _keychainStorage.add(KeychainKeys.expiresAt, response.expiresAt),
      _keychainStorage.add(KeychainKeys.userId, response.userId),
      _keychainStorage.add(KeychainKeys.steamId, response.steamId),
    ]);

    return userResponse;
  }
}
