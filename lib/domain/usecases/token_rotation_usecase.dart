import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/date_time_utils.dart';
import 'package:dotagiftx_mobile/core/utils/retry_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/usecases/refresh_token_usecase.dart';
import 'package:injectable/injectable.dart';

abstract interface class TokenRotationUsecase {
  Future<void> refreshTokenRotation();
  Future<void> start();
}

@LazySingleton(as: TokenRotationUsecase)
class TokenRotationUsecaseImpl implements TokenRotationUsecase {
  final Logger _logger;
  final KeychainStorage _keychainStorage;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;
  final RefreshTokenUsecase _refreshTokenUsecase;
  final DateTimeUtils _dateTimeUtils;
  final RetryUtils _retryUtils;

  TokenRotationUsecaseImpl(
    this._logger,
    this._keychainStorage,
    this._dotagiftxRemoteConfig,
    this._refreshTokenUsecase,
    this._dateTimeUtils,
    this._retryUtils,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<void> refreshTokenRotation() async {
    final expiresAtString = await _keychainStorage.getValue(
      KeychainKeys.expiresAt,
    );

    final expiresAt = DateTime.parse(expiresAtString!).toLocal();

    _logger.log(LogLevel.debug, 'expiresAtString: $expiresAtString');
    _logger.log(LogLevel.debug, 'expiresAt: $expiresAt');

    final currentTime = _dateTimeUtils.getLocalDateTime();
    final isAfterThreshold = currentTime.isAfter(expiresAt);
    if (isAfterThreshold) {
      _logger.log(LogLevel.debug, 'threshold reached: refreshTokenRotation()');
      try {
        await _refreshTokenUsecase.refresh();
      } catch (e) {
        // ignore if refresh token fails, let interceptor handles logout
      }
    }
  }

  @override
  Future<void> start() async {
    final tokenRotationSeconds =
        await _dotagiftxRemoteConfig.getTokenRotationSeconds();

    try {
      await _refreshTokenUsecase.refresh();
    } catch (e) {
      // ignore refresh token, still start the timer and let interceptor handles logout
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
        // if refresh token failed, ignore and let interceptor handles logout
      }
    });
  }
}
