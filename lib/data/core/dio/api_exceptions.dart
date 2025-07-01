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
  BadRequestException({required super.error});
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
