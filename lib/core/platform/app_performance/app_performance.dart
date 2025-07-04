abstract interface class AppPerformance {
  // list of traces
  static const String appSplashDuration = 'app_splash_duration';

  Future<void> startTrace(String name);
  Future<void> stopTrace(String name);
  Future<void> setMetric(String name, String metricName, int value);
  Future<void> setAttribute(String name, String attributeName, String value);
}
