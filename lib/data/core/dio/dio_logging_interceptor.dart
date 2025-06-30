import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:flutter/foundation.dart';

class DioLoggingInterceptor extends Interceptor {
  static const keysToMask = <String>[
    'token',
    'access_token',
    'refresh_token',
    'client_id',
    'client_secret',
  ];

  static const maxLengthMaskedValue = 5;

  final Logger _logger;

  DioLoggingInterceptor(this._logger);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final tag = '[RES#${shortHash(err.requestOptions)}]';
    _logger
      ..log(
        LogLevel.debug,
        '$tag Failed: ${err.response?.statusCode} ${err.response?.statusMessage}',
      )
      ..log(LogLevel.debug, '$tag Failed Body: ${err.response?.data}');

    super.onError(err, handler);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tag = '[REQ#${shortHash(options)}]';

    options.headers.addEntries([
      const MapEntry('App-Name', 'Dotagiftx-mobile'),
    ]);

    final reqUri = options.uri;
    _logger
      ..log(
        LogLevel.debug,
        '$tag Sending ${options.method.toUpperCase()} $reqUri',
      )
      ..log(
        LogLevel.debug,
        '$tag Headers: ${options.headers.map((key, value) {
          // trim token value for security purposes
          if (key.toLowerCase() == 'authorization') {
            final token = value.toString();
            return MapEntry(key, token.length > maxLengthMaskedValue ? '${token.substring(0, maxLengthMaskedValue)}...' : token);
          } else {
            return MapEntry(key, value.toString());
          }
        })}',
      )
      ..log(LogLevel.debug, '$tag Host: ${reqUri.host}')
      ..log(LogLevel.debug, '$tag Scheme: ${reqUri.scheme.toUpperCase()}');

    if (options.data is Map || options.data is List) {
      final encodedBody = _maskSensitiveData(_encodeBody(options.data));
      _logger.log(LogLevel.debug, '$tag Body: $encodedBody');
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final tag = '[RES#${shortHash(response.requestOptions)}]';

    _logger.log(
      LogLevel.debug,
      '$tag Success: ${response.statusCode} ${response.statusMessage}',
    );

    if (response.data is Map || response.data is List) {
      final encodedBody = _maskSensitiveData(_encodeBody(response.data));
      _logger.log(LogLevel.debug, '$tag Body: $encodedBody');
    }

    super.onResponse(response, handler);
  }

  String _encodeBody(Object? body) {
    const encoder = JsonEncoder.withIndent('    ');

    return encoder.convert(body);
  }

  String? _maskSensitiveData(String? body) {
    final pattern = keysToMask
        .map((key) => '"$key"\\s*:\\s*"([^"]+)"')
        .join('|');
    final regex = RegExp(pattern);

    return body?.replaceAllMapped(regex, (match) {
      final keyValuePair =
          match.group(0) ??
          ''; // full match example: "access_token": "some-value"

      // find the correct value (group index > 0 and not null)
      String? value;
      for (var i = 1; i <= match.groupCount; i++) {
        if (match.group(i) != null) {
          value = match.group(i);
          break;
        }
      }

      if (value == null) {
        return keyValuePair; // If no valid value found, return as is
      }

      final maskedValue =
          value.length > maxLengthMaskedValue
              ? '${value.substring(0, maxLengthMaskedValue)}...'
              : value;

      return keyValuePair.replaceFirst(value, maskedValue);
    });
  }
}
