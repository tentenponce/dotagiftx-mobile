import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_performance/app_performance.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppPerformance)
class FirebaseAppPerformance implements AppPerformance {
  final Logger _logger;

  final Map<String, Trace> _activeTraces = {};

  FirebaseAppPerformance(this._logger);

  @override
  Future<void> setAttribute(
    String name,
    String attributeName,
    String value,
  ) async {
    try {
      final trace = _activeTraces[name];
      if (trace != null) {
        trace.putAttribute(attributeName, value);
      }
    } catch (e) {
      _logger.log(
        LogLevel.error,
        'Failed to set Firebase attribute $attributeName on trace $name: $e',
      );
    }
  }

  @override
  Future<void> setMetric(String name, String metricName, int value) async {
    try {
      final trace = _activeTraces[name];
      if (trace != null) {
        trace.setMetric(metricName, value);
      }
    } catch (e) {
      _logger.log(
        LogLevel.error,
        'Failed to set Firebase metric $metricName on trace $name: $e',
      );
    }
  }

  @override
  Future<void> startTrace(String name) async {
    try {
      final trace = FirebasePerformance.instance.newTrace(
        _truncateTraceName(name),
      );
      await trace.start();
      _activeTraces[name] = trace;
    } catch (e) {
      _logger.log(LogLevel.error, 'Failed to start Firebase trace $name: $e');
    }
  }

  @override
  Future<void> stopTrace(String name) async {
    try {
      final trace = _activeTraces.remove(name);
      if (trace != null) {
        await trace.stop();
      }
    } catch (e) {
      _logger.log(LogLevel.error, 'Failed to stop Firebase trace $name: $e');
    }
  }

  String _truncateTraceName(String name) {
    if (name.length > 100) {
      // truncate trace name if it exceeds 100 characters because this is crashing on iOS
      return name.substring(0, 100);
    }

    return name;
  }
}
