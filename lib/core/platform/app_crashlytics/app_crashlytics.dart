import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/log_level.dart';
import 'package:dotagiftx_mobile/core/logging/log_object.dart';
import 'package:dotagiftx_mobile/core/logging/log_stream_provider.dart';
import 'package:flutter/foundation.dart';

abstract interface class AppCrashlytics {
  Future<void> logMessage(String message);

  Future<void> reportError(Object error, StackTrace? stack);

  Future<void> setUserId(String userId);

  void startTracking();
}

abstract class BaseAppCrashlyticsImpl implements AppCrashlytics {
  final LogStreamProvider _logStreamProvider;

  StreamSubscription<LogObject>? _logSubscription;

  BaseAppCrashlyticsImpl(this._logStreamProvider);

  @override
  void startTracking() {
    _reportLogs();
    _reportFlutterError();
    _reportPlatformError();
  }

  void _reportError(Object error, StackTrace? stack) {
    unawaited(reportError(error, stack));
  }

  void _reportFlutterError() {
    FlutterError.onError = (details) {
      _reportError(details.exception, details.stack);
    };
  }

  void _reportLogs() {
    unawaited(_logSubscription?.cancel());
    _logSubscription = _logStreamProvider.valueStream.listen((log) async {
      await logMessage(log.formattedMessage);
      if (log.level == LogLevel.error) {
        await reportError(log.error ?? Exception(log.message), log.stackTrace);
      }
    });
  }

  void _reportPlatformError() {
    PlatformDispatcher.instance.onError = (error, stack) {
      _reportError(error, stack);
      return true;
    };
  }
}
