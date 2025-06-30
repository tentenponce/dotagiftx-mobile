import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/dio/dio_error_interceptor.dart';
import 'package:dotagiftx_mobile/data/core/dio/dio_logging_interceptor.dart';
import 'package:injectable/injectable.dart';

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

abstract interface class BasicDioProvider {
  Dio create<T>();
}

@Injectable(as: BasicDioProvider)
class BasicDioProviderImpl extends BaseDioProvider implements BasicDioProvider {
  BasicDioProviderImpl(super._logger);
}
