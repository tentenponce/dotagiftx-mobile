import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_analytics/app_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppAnalytics)
class FirebaseAppAnalytics implements AppAnalytics {
  final Logger _logger;
  late FirebaseAnalytics _firebaseAnalytics;

  FirebaseAppAnalytics(this._logger) {
    _logger.logFor(this);
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> logEvent({
    required String name,
    Map<String, String>? parameters,
  }) async {
    _logger.log(
      LogLevel.debug,
      'FirebaseAppAnalytics > logEvent > name: $name, parameters: $parameters',
    );
    return _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }
}
