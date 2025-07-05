import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/presentation/app/init_app.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      registerInitialDependencies();
      runApp(const InitApp());
    },
    (e, st) {
      final logger = getIt<Logger>();
      logger.log(LogLevel.error, 'runZonedGuarded exception: $e', e, st);
    },
  );
}
