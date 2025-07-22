import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/retry_utils.dart';
import 'package:dotagiftx_mobile/data/core/dio/dio_auth_interceptor.dart';
import 'package:dotagiftx_mobile/data/core/dio/dio_error_interceptor.dart';
import 'package:dotagiftx_mobile/data/core/dio/dio_logging_interceptor.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/usecases/refresh_token_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthDioProviderImpl extends BaseDioProvider implements DioProvider {
  final SharedPreferenceStorage _sharedPreferenceStorage;
  final KeychainStorage _keychainStorage;
  final RetryUtils _retryUtils;
  final RefreshTokenUsecase _refreshTokenUsecase;

  AuthDioProviderImpl(
    super._logger,
    this._sharedPreferenceStorage,
    this._keychainStorage,
    this._retryUtils,
    this._refreshTokenUsecase,
  );

  @override
  Dio create<T>({bool bypassUnauthorizeEndpoints = false}) {
    final dio = super.create<T>();
    dio.interceptors.insert(
      2, // Insert before DioLoggingInterceptor
      DioAuthInterceptor(
        _logger,
        dio,
        _sharedPreferenceStorage,
        _keychainStorage,
        _refreshTokenUsecase,
        _retryUtils,
      ),
    );

    return dio;
  }
}

abstract class BaseDioProvider {
  static const _timeout = Duration(seconds: 30);

  final Logger _logger;

  BaseDioProvider(this._logger);

  Dio create<T>() {
    _logger.logFor<T>();

    final dio = Dio(
      BaseOptions(
        connectTimeout: _timeout,
        sendTimeout: _timeout,
        receiveTimeout: _timeout,
      ),
    );
    dio.interceptors.addAll([
      DioErrorInterceptor(),
      DioLoggingInterceptor(_logger),
    ]);

    return dio;
  }
}

abstract interface class DioProvider {
  Dio create<T>();
}

@injectable
class UnauthDioProviderImpl extends BaseDioProvider implements DioProvider {
  UnauthDioProviderImpl(super._logger);
}
