import 'dart:developer' as dev;

import 'package:dotagiftx_mobile/core/logging/log_level.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

export 'log_level.dart';

abstract interface class Logger {
  void log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]);

  void logFor<T>([T? object]);
}

@Injectable(as: Logger)
class LoggerImpl implements Logger {
  String _owner = '';

  LoggerImpl();

  @override
  void log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    dev.log(
      _formatMessage(level, message, error, stackTrace),
      name: _owner,
      level: level.value,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void logFor<T>([T? object]) {
    _owner = object != null ? describeIdentity(object) : '$T';
  }

  static String _formatMessage(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    final tag = '[${level.name.toUpperCase()}]';
    var formattedMessage = '$tag $message';

    if (level == LogLevel.error && error != null) {
      formattedMessage += '\r\n${error.runtimeType} $error';
    }

    if (level == LogLevel.error && stackTrace != null) {
      formattedMessage += '\r\n$stackTrace';
    }

    return formattedMessage;
  }
}
