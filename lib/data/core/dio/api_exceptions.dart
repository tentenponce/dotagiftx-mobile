import 'package:dio/dio.dart';

class ApiException extends DioException {
  ApiException({required DioException error})
    : super(
        requestOptions: error.requestOptions,
        response: error.response,
        error: error.error,
      );
}

class BadRequestException extends ApiException {
  final String? apiErrorMessage;
  final int statusCode;

  BadRequestException({
    required super.error,
    required this.statusCode,
    this.apiErrorMessage,
  });
}

class NetworkTimeoutException extends ApiException {
  NetworkTimeoutException({required super.error});
}

class ServerUnavailableException extends ApiException {
  ServerUnavailableException({required super.error});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required super.error});
}

class UnknownException extends ApiException {
  UnknownException({required super.error});
}
