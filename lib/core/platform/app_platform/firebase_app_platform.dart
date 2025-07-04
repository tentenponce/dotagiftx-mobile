import 'dart:async';

import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_analytics/app_analytics.dart';
import 'package:dotagiftx_mobile/core/platform/app_crashlytics/app_crashlytics.dart';
import 'package:dotagiftx_mobile/core/platform/app_platform/app_platform.dart';
import 'package:dotagiftx_mobile/core/platform/app_remote_config/app_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppPlatform)
class FirebaseAppPlatform implements AppPlatform {
  final Logger _logger;
  final EnvironmentVariables _environmentVariables;
  final AppCrashlytics _appCrashlytics;
  final AppAnalytics _appAnalytics;
  final AppRemoteConfig _appRemoteConfig;

  FirebaseAppPlatform(
    this._logger,
    this._environmentVariables,
    this._appAnalytics,
    this._appCrashlytics,
    this._appRemoteConfig,
  ) {
    _logger.logFor(this);
  }

  @override
  Future<void> initPlatform() async {
    _logger.log(LogLevel.info, 'Firebase apps: ${Firebase.apps}');
    if (Firebase.apps.isEmpty) {
      try {
        await Firebase.initializeApp(
          options: switch (defaultTargetPlatform) {
            TargetPlatform.android => FirebaseOptions(
              apiKey: _environmentVariables.firebaseApiKey,
              appId: _environmentVariables.firebaseAppId,
              messagingSenderId: '',
              projectId: _environmentVariables.firebaseProjectId,
              storageBucket: _environmentVariables.firebaseStorageBucket,
            ),
            _ => throw UnsupportedError('Current platform is not supported'),
          },
        );
        _logger.log(LogLevel.info, 'Firebase Initalized');
      } catch (e, st) {
        // ignore error
        _logger.log(LogLevel.error, 'Error intializing Firebase', e, st);
        // we will ignore the error and initialize the analytics, crashlytics and remote config services
      }
    }
    await _tryInitializeServices();
  }

  Future<void> _tryInitializeServices() async {
    _logger.log(LogLevel.info, 'Initializing Firebase Services');
    _appCrashlytics.startTracking();

    // don't wait for these services to initialize, its not critical for now
    unawaited(_appRemoteConfig.init());
    unawaited(_appAnalytics.init());
  }
}
