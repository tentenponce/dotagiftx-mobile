import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_platform/app_platform.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/presentation/app/app.dart';
import 'package:dotagiftx_mobile/presentation/shared/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

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
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: const Color(0xFF515151),
            body: Center(
              child: Assets.icon.icon.image(height: 100, width: 100),
            ),
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

    final logger = getIt<Logger>();
    final keychainStorage = getIt<KeychainStorage>();
    final userId = await keychainStorage.getValue(KeychainKeys.userId);

    if (StringUtils.isNullOrEmpty(userId)) {
      // Generate proper UUID for user ID
      final newUserId = const Uuid().v4();
      logger.log(
        LogLevel.info,
        'User ID is null, adding new user ID: $newUserId',
      );
      await keychainStorage.add(KeychainKeys.userId, newUserId);
    } else {
      logger.log(LogLevel.info, 'User ID: $userId');
    }

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return 'done';
  }
}
