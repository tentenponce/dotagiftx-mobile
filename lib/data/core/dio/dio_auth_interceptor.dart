import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/retry_utils.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/usecases/refresh_token_usecase.dart';

class DioAuthInterceptor extends Interceptor {
  // if this gets longer, consider creating separate setup dio,
  // for optional auth endpoints
  static const _optionalAuthEndpoints = ['/markets'];

  final Logger _logger;
  final Dio _dio;
  final SharedPreferenceStorage _sharedPreferenceStorage;
  final KeychainStorage _keychainStorage;
  final RefreshTokenUsecase _refreshTokenUsecase;
  final RetryUtils _retryUtils;

  DioAuthInterceptor(
    this._logger,
    this._dio,
    this._sharedPreferenceStorage,
    this._keychainStorage,
    this._refreshTokenUsecase,
    this._retryUtils,
  );

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.response?.requestOptions;
    if (err.response?.statusCode == 401) {
      _logger.log(
        LogLevel.debug,
        '401 encountered checking retry count: ${options?.headers['Retry-Count']}',
      );
      if (options?.headers['Retry-Count'] == 1) {
        await _logout();

        return super.onError(err, handler);
      }

      try {
        return await _retryApiCall(handler, options);
      } catch (e) {
        await _logout();

        return super.onError(
          DioException(requestOptions: err.requestOptions, error: e),
          handler,
        );
      }
    } else {
      return super.onError(err, handler);
    }
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Future<String?> getAccessToken() =>
        _keychainStorage.getValue(KeychainKeys.token);
    Future<String?> getRefreshToken() =>
        _keychainStorage.getValue(KeychainKeys.refreshToken);
    Future<bool> hasAccessToken() async =>
        !StringUtils.isNullOrEmpty(await getAccessToken());
    Future<bool> hasRefreshToken() async =>
        !StringUtils.isNullOrEmpty(await getRefreshToken());
    bool containsAuthHeader() =>
        !StringUtils.isNullOrEmpty(options.headers['Authorization'] as String?);
    bool isOptionalAuthEndpoint() =>
        _optionalAuthEndpoints.any(options.path.contains);

    // if the endpoint requires auth and auth header does not exists OR if endpoint is optional auth endpoint,
    // then add the token
    if ((!containsAuthHeader() &&
            await hasAccessToken() &&
            options.baseUrl.isNotEmpty) ||
        isOptionalAuthEndpoint()) {
      options.headers['Authorization'] = 'Bearer ${await getAccessToken()}';
    }
    // if the endpoint requires auth but does not have a token or auth header, and has refresh token, refresh the token
    else if (!containsAuthHeader() &&
        await hasRefreshToken() &&
        options.baseUrl.isNotEmpty) {
      try {
        await _refreshTokenUsecase.refresh();
        options.headers['Authorization'] = 'Bearer ${await getAccessToken()}';
      } catch (e) {
        await _logout();

        return;
      }
    }

    // otherwise do not call the API and logout the user
    if (!containsAuthHeader() && options.baseUrl.isNotEmpty) {
      await _logout();

      return;
    }

    super.onRequest(options, handler);
  }

  Future<void> _logout() async {
    await Future.wait([
      _sharedPreferenceStorage.clear(SharedPreferencesKeys.user),
      _keychainStorage.clearAll(),
    ]);
  }

  /// this is to handle race condition if token rotation usecase is triggered together with an API call
  Future<void> _retryApiCall(
    ErrorInterceptorHandler handler,
    RequestOptions? options,
  ) async {
    return _retryUtils.invoke(
      delay: const Duration(seconds: 1),
      action: () async {
        // refresh token
        await _refreshTokenUsecase.refresh();

        // re-fetch the access token from keychain again
        final accessToken = await _keychainStorage.getValue(KeychainKeys.token);

        options?.headers['Retry-Count'] =
            1; //setting retry count to 1 to prevent further concurrent calls
        options?.headers['Authorization'] = 'Bearer $accessToken';

        // if token is null, throwing exception to trigger logout
        if (StringUtils.isNullOrEmpty(accessToken)) {
          throw UnauthorizedException(
            error: DioException(requestOptions: options!),
          );
        }

        return handler.resolve(await _dio.fetch(options!));
      },
    );
  }
}
