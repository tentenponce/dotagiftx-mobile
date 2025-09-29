import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';

class DioErrorInterceptor extends Interceptor {
  DioErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _errorToException(err);

    super.onError(exception, handler);
  }

  ApiException _errorToException(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final errorMap = _tryGetErrorCode(error.response?.data);

    final errorMessage =
        !StringUtils.isNullOrEmpty(errorMap?['msg'].toString())
            ? errorMap!['msg'].toString()
            : error.message;

    if (statusCode >= 400 && statusCode < 500) {
      return switch (statusCode) {
        401 => UnauthorizedException(error: error),
        _ => BadRequestException(
          error: error,
          apiErrorMessage: errorMessage,
          statusCode: statusCode,
        ),
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

  Map<String?, Object?>? _tryGetErrorCode(Object? response) {
    if (response == null || (response is String && response.isEmpty)) {
      return null;
    }

    try {
      return (response as Map?)?.cast<String?, Object?>();
    } catch (e) {
      // if failed casting, try casting the data to string
      return {'msg': response.toString()};
    }
  }
}
