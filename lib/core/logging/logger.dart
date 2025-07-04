import 'dart:developer' as dev;

import 'package:dotagiftx_mobile/core/logging/log_level.dart';
import 'package:dotagiftx_mobile/core/logging/log_object.dart';
import 'package:dotagiftx_mobile/core/logging/log_stream_provider.dart';
import 'package:dotagiftx_mobile/di/dependency_scopes.dart';
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

@Scope(DependencyScopes.initial)
@Injectable(as: Logger)
class LoggerImpl implements Logger {
  final LogStreamPublisher _logStreamPublisher;

  String _owner = '';

  LoggerImpl(this._logStreamPublisher);

  @override
  void log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final logObject = LogObject(
      level: level,
      message: message,
      owner: _owner.isEmpty ? 'log' : _owner,
      error: error,
      stackTrace: stackTrace,
    );

    dev.log(
      logObject.formattedMessage,
      name: _owner,
      level: level.value,
      // ignore: limit_datetime_now_usage
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
    _logStreamPublisher.addLog(logObject);
  }

  @override
  void logFor<T>([T? object]) {
    _owner = object != null ? describeIdentity(object) : '$T';
  }
}
