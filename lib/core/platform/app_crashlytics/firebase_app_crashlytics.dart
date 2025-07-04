import 'package:dotagiftx_mobile/core/platform/app_crashlytics/app_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AppCrashlytics)
class AndroidIosAppCrashlyticsImpl extends BaseAppCrashlyticsImpl {
  late final FirebaseCrashlytics _firebaseCrashlytics =
      FirebaseCrashlytics.instance;

  AndroidIosAppCrashlyticsImpl(super._logStreamProvider);

  @override
  Future<void> logMessage(String message) async {
    if (!_isFirebaseCrashlyticsAvailable()) {
      return;
    }

    await _firebaseCrashlytics.log(message);
  }

  @override
  Future<void> reportError(Object error, StackTrace? stack) async {
    if (!_isFirebaseCrashlyticsAvailable()) {
      return;
    }

    await _firebaseCrashlytics.recordError(error, stack);
  }

  @override
  Future<void> setUserId(String userId) async {
    if (!_isFirebaseCrashlyticsAvailable()) {
      return;
    }

    await _firebaseCrashlytics.setUserIdentifier(userId);
  }

  static bool _isFirebaseCrashlyticsAvailable() {
    return kReleaseMode && Firebase.apps.isNotEmpty;
  }
}
