abstract interface class AppPerformance {
  Future<void> setAttribute(String name, String attributeName, String value);
  Future<void> setMetric(String name, String metricName, int value);
  Future<void> startTrace(String name);
  Future<void> stopTrace(String name);
}
