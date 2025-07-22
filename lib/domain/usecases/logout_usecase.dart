import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/data/requests/revoke_token_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class LogoutUsecase {
  Future<void> call();
}

@LazySingleton(as: LogoutUsecase)
class LogoutUsecaseImpl implements LogoutUsecase {
  final Logger _logger;
  final DotagiftxUnauthApi _dotagiftxUnauthApi;
  final KeychainStorage _keychainStorage;
  final SharedPreferenceStorage _sharedPreferenceStorage;

  LogoutUsecaseImpl(
    this._logger,
    this._dotagiftxUnauthApi,
    this._keychainStorage,
    this._sharedPreferenceStorage,
  );

  @override
  Future<void> call() async {
    final refreshToken = await _keychainStorage.getValue(
      KeychainKeys.refreshToken,
    );

    // no need to wait, as simply deleting info from storage is enough
    unawaited(_revokeToken(refreshToken ?? ''));

    // clear user from storage and all keychain related keys
    await Future.wait([
      _sharedPreferenceStorage.clear(SharedPreferencesKeys.user),
      _keychainStorage.clearAll(),
    ]);
  }

  Future<void> _revokeToken(String refreshToken) async {
    try {
      await _dotagiftxUnauthApi.revokeToken(
        RevokeTokenRequest(refreshToken: refreshToken),
      );
    } catch (e) {
      // ignore any errors when revoking token
      _logger.log(LogLevel.warning, 'error revoking token', e);
    }
  }
}
