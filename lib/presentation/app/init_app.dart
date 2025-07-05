import 'dart:async';

import 'package:dotagiftx_mobile/core/platform/app_platform/app_platform.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/presentation/app/app.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  late final Future<String?> _initApp;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _initApp,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const App();
        }
        return const Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: AppColors.primary,
            body: SizedBox.shrink(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initApp = Future(_initializeApp);
  }

  Future<String?> _initializeApp() async {
    configureDependencies();

    final appPlatform = getIt<AppPlatform>();
    await appPlatform.initPlatform();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return 'done';
  }
}
