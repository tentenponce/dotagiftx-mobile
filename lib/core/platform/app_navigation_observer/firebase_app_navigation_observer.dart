import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_navigation_observer/app_navigation_observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppNavigationObserver)
class FirebaseAppNavigationObserver implements AppNavigationObserver {
  final Logger _logger;
  // avoid double-logging the same visible route
  String? _lastLoggedScreen;

  FirebaseAppNavigationObserver(this._logger) {
    _logger.logFor(this);
  }

  @override
  void logNavigation({
    required String screenName,
    required String screenClass,
  }) {
    // avoid double-logging the same visible route
    final dedupeKey = '$screenName#$screenClass';
    if (_lastLoggedScreen == dedupeKey) {
      return;
    }
    _lastLoggedScreen = dedupeKey;

    _logger.log(
      LogLevel.info,
      'logNavigation > screenName: $screenName, screenClass: $screenClass',
    );

    unawaited(
      FirebaseAnalytics.instance.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      ),
    );
  }
}
