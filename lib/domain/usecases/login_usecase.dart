import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:injectable/injectable.dart';

abstract interface class LoginUsecase {
  Future<void> call(String openid);
}

@LazySingleton(as: LoginUsecase)
class LoginUsecaseImpl implements LoginUsecase {
  final DotagiftxApi dotagiftxApi;
  final KeychainStorage keychainStorage;

  LoginUsecaseImpl(this.dotagiftxApi, this.keychainStorage);

  @override
  Future<void> call(String openid) async {
    final response = await dotagiftxApi.loginSteam(openid);

    await Future.wait([
      keychainStorage.add(KeychainKeys.token, response.token),
      keychainStorage.add(KeychainKeys.refreshToken, response.refreshToken),
      keychainStorage.add(KeychainKeys.expiresAt, response.expiresAt),
      keychainStorage.add(KeychainKeys.userId, response.userId),
      keychainStorage.add(KeychainKeys.steamId, response.steamId),
    ]);
  }
}
