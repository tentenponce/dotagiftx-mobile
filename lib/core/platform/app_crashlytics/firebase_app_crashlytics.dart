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

    if (stack != null) {
      // Get the first non-AndroidIosAppCrashlyticsImpl frame from the stack trace
      final frames = stack.toString().split('\n');
      String? sourceFrame;
      for (final frame in frames) {
        if (!frame.contains('AndroidIosAppCrashlyticsImpl')) {
          sourceFrame = frame;
          break;
        }
      }

      if (sourceFrame != null) {
        // Extract class and method name from the stack frame
        final match = RegExp(r'#\d+\s+([^(]+)').firstMatch(sourceFrame);
        if (match != null) {
          final sourceInfo = match.group(1)?.trim();
          if (sourceInfo != null) {
            await _firebaseCrashlytics.setCustomKey('error_source', sourceInfo);
          }
        }
      }
    } else {
      await _firebaseCrashlytics.setCustomKey('error_source', error.toString());
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
