import 'package:dotagiftx_mobile/core/logging/log_level.dart';

class LogObject {
  final LogLevel level;
  final String message;
  final String owner;
  final Object? error;
  final StackTrace? stackTrace;

  LogObject({
    required this.level,
    required this.message,
    required this.owner,
    this.error,
    this.stackTrace,
  });

  String get formattedMessage {
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
