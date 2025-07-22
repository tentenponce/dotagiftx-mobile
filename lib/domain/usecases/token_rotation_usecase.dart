import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/retry_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/usecases/refresh_token_usecase.dart';
import 'package:injectable/injectable.dart';

abstract interface class TokenRotationUsecase {
  Future<void> start();
}

@LazySingleton(as: TokenRotationUsecase)
class TokenRotationUsecaseImpl implements TokenRotationUsecase {
  final Logger _logger;
  final KeychainStorage _keychainStorage;
  final SharedPreferenceStorage _sharedPreferenceStorage;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;
  final RefreshTokenUsecase _refreshTokenUsecase;
  final RetryUtils _retryUtils;

  TokenRotationUsecaseImpl(
    this._logger,
    this._keychainStorage,
    this._sharedPreferenceStorage,
    this._dotagiftxRemoteConfig,
    this._refreshTokenUsecase,
    this._retryUtils,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<void> start() async {
    final tokenRotationSeconds =
        await _dotagiftxRemoteConfig.getTokenRotationSeconds();

    try {
      await _refreshTokenUsecase.refresh();
    } catch (e) {
      await _handleRefreshTokenError(e);
    }

    Timer.periodic(Duration(seconds: tokenRotationSeconds), (_) async {
      _logger.log(LogLevel.debug, 'attempting to refresh token...');
      try {
        await _retryUtils.invoke(
          delay: const Duration(seconds: 1),
          action: () async {
            await _refreshTokenUsecase.refresh();
          },
        );
      } catch (e) {
        await _handleRefreshTokenError(e);
      }
    });
  }

  Future<void> _handleRefreshTokenError(Object e) async {
    if (e is UnauthorizedException) {
      _logger.log(LogLevel.debug, 'logging out...');
      await _logout();
    } else {
      _logger.log(LogLevel.error, 'error refreshing token: $e', e);
    }
  }

  Future<void> _logout() async {
    await Future.wait([
      _sharedPreferenceStorage.clear(SharedPreferencesKeys.user),
      _keychainStorage.clearAll(),
    ]);
  }
}
