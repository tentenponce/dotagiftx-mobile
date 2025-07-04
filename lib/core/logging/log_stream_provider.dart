import 'package:dotagiftx_mobile/core/logging/log_object.dart';
import 'package:rxdart/rxdart.dart';

class LogStreamHandler implements LogStreamProvider, LogStreamPublisher {
  static LogStreamHandler? _instance;

  final ReplaySubject<LogObject> _logStream = ReplaySubject<LogObject>();

  factory LogStreamHandler() {
    return _instance ??= LogStreamHandler._();
  }

  LogStreamHandler._();

  @override
  Iterable<LogObject> get values => _logStream.values;

  @override
  Stream<LogObject> get valueStream => _logStream.stream;

  @override
  void addLog(LogObject log) {
    _logStream.add(log);
  }
}

abstract interface class LogStreamProvider {
  Iterable<LogObject> get values;

  Stream<LogObject> get valueStream;
}

abstract interface class LogStreamPublisher {
  void addLog(LogObject log);
}
