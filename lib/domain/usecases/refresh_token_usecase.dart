import 'dart:async';

import 'package:async/async.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/retry_utils.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/requests/refresh_token_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class RefreshTokenUsecase {
  Future<String?> refresh();
}

@LazySingleton(as: RefreshTokenUsecase)
class RefreshTokenUsecaseImpl implements RefreshTokenUsecase {
  final Logger _logger;
  final KeychainStorage _keychainStorage;
  final DotagiftxUnauthApi _dotagiftxUnauthApi;
  final RetryUtils _retryUtils;

  final _refreshTokenAsyncCache = AsyncCache<String>.ephemeral();

  RefreshTokenUsecaseImpl(
    this._logger,
    this._keychainStorage,
    this._dotagiftxUnauthApi,
    this._retryUtils,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<String?> refresh() async {
    final refreshToken = await _keychainStorage.getValue(
      KeychainKeys.refreshToken,
    );

    /// do not call if there's no refresh token in the first place
    /// to handle fresh installs
    if (StringUtils.isNullOrEmpty(refreshToken)) {
      return null;
    }

    return _refreshToken(refreshToken!);
  }

  Future<String> _refreshToken(String refreshToken) async {
    return _refreshTokenAsyncCache.fetch(() async {
      final authRefreshResp = await _retryUtils.invoke(
        delay: Duration.zero,
        maxRetry: 2,
        action: () async {
          final authRefreshResp = await _dotagiftxUnauthApi.refreshToken(
            RefreshTokenRequest(refreshToken: refreshToken),
          );

          return authRefreshResp;
        },
      );

      await Future.wait([
        _keychainStorage.add(KeychainKeys.token, authRefreshResp!.token),
        _keychainStorage.add(KeychainKeys.expiresAt, authRefreshResp.expiresAt),
      ]);

      return authRefreshResp.token;
    });
  }
}
