import 'dart:async';

abstract interface class AppAnalytics {
  Future<void> init();
  Future<void> logEvent({
    required String name,
    Map<String, String>? parameters,
  });
}
