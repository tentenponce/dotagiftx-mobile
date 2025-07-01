import 'dart:async';
import 'dart:ui';

import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/presentation/app/app.dart';
import 'package:flutter/material.dart';

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

    configureDependencies();
    runApp(const App());
  }, catchUnhandledExceptions);
}

void catchUnhandledExceptions(Object error, StackTrace? stack) {
  debugPrintStack(stackTrace: stack, label: error.toString());
}
