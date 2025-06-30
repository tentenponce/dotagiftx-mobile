import 'package:dio/dio.dart';

class ApiException extends DioException {
  final String? errorCode;
  final String? errorMessage;

  ApiException({required DioException error, this.errorCode, this.errorMessage})
    : super(
        requestOptions: error.requestOptions,
        response: error.response,
        error: error.error,
      );

  String get method => requestOptions.method;

  String? get reasonPhrase => response?.statusMessage;

  Object? get responseBody => response?.data;

  int? get statusCode => response?.statusCode;

  Uri get uri => requestOptions.uri;
}

class BadRequestException extends ApiException {
  BadRequestException({
    required super.error,
    super.errorCode,
    super.errorMessage,
  });
}

class NetworkTimeoutException extends ApiException {
  NetworkTimeoutException({
    required super.error,
    super.errorCode,
    super.errorMessage,
  });
}

class ServerUnavailableException extends ApiException {
  ServerUnavailableException({
    required super.error,
    super.errorCode,
    super.errorMessage,
  });
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required super.error, super.errorCode});
}

class UnknownException extends ApiException {
  UnknownException({required super.error, super.errorCode, super.errorMessage});
}
