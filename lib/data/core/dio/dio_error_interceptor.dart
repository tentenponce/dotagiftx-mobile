import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';

class DioErrorInterceptor extends Interceptor {
  DioErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _errorToException(err);

    super.onError(exception, handler);
  }

  static ApiException _errorToException(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;

    if (statusCode >= 400 && statusCode < 500) {
      return switch (statusCode) {
        401 => UnauthorizedException(error: error),
        _ => BadRequestException(error: error),
      };
    } else if (statusCode >= 500 && statusCode < 600) {
      return ServerUnavailableException(error: error);
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.unknown ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return NetworkTimeoutException(error: error);
    } else {
      return UnknownException(error: error);
    }
  }
}
