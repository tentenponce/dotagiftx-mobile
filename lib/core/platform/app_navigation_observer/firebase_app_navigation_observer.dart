import 'package:dotagiftx_mobile/core/platform/app_navigation_observer/app_navigation_observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppNavigationObserver)
class FirebaseAppNavigationObserver extends FirebaseAnalyticsObserver
    implements AppNavigationObserver {
  FirebaseAppNavigationObserver()
    : super(analytics: FirebaseAnalytics.instance);
}
