import 'dart:async';
import 'dart:ui';

import 'package:dotagiftx_mobile/core/platform/app_platform/app_platform.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/presentation/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      catchUnhandledExceptions(details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      catchUnhandledExceptions(error, stack);
      return true;
    };

    // TODO(tenten): add splash and load other dependencies there to make app start faster
    registerInitialDependencies();
    configureDependencies();

    final appPlatform = GetIt.instance<AppPlatform>();
    unawaited(appPlatform.initPlatform());

    runApp(const App());
  }, catchUnhandledExceptions);
}

void catchUnhandledExceptions(Object error, StackTrace? stack) {
  debugPrintStack(stackTrace: stack, label: error.toString());
}
