import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_navigation_observer/app_navigation_observer.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract interface class NavigationLogger implements NavigatorObserver {
  String getPreviousRouteName();
}

@LazySingleton(as: NavigationLogger)
class NavigationLoggerImpl extends RouteObserver<ModalRoute<dynamic>>
    implements NavigationLogger {
  final Logger _logger;
  final AppNavigationObserver _appNavigationObserver;
  Route<dynamic>? _previousRoute;

  // avoid double-logging the same visible route
  String? _lastLoggedScreen;

  NavigationLoggerImpl(this._logger, this._appNavigationObserver) {
    _logger.logFor<NavigationLoggerImpl>();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _previousRoute = route;
    _logger.log(
      LogLevel.info,
      '${_getRoutePath(previousRoute)} <== POPPED === ${_getRoutePath(route)}',
    );
    unawaited(_logScreen(previousRoute));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _previousRoute = previousRoute;
    _logger.log(
      LogLevel.info,
      '${_getRoutePath(previousRoute)} === PUSHED ==> ${_getRoutePath(route)}',
    );
    unawaited(_logScreen(route));
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _previousRoute = oldRoute;
    _logger.log(
      LogLevel.info,
      '${_getRoutePath(oldRoute)} === REPLACED ==> ${_getRoutePath(newRoute)}',
    );
    unawaited(_logScreen(newRoute));
  }

  @override
  String getPreviousRouteName() {
    return _getRoutePath(_previousRoute);
  }

  String _getRoutePath(Route<dynamic>? route) {
    final routeSettings = route?.settings;

    return routeSettings?.name ?? '';
  }

  Future<void> _logScreen(Route<dynamic>? route) async {
    if (route == null) {
      return;
    }

    final screenName = _getRoutePath(route);

    if (screenName.isEmpty) {
      _logger.log(
        LogLevel.error,
        'Screen name is empty: $screenName (${route.runtimeType})',
        Exception('Screen name is empty'),
        StackTrace.current,
      );
      return;
    }

    // Try to get a meaningful screenClass; prefer what you injected at push time.
    var screenClass = route.runtimeType.toString();
    final args = route.settings.arguments;
    if (args is Map && args['screenClass'] is String) {
      screenClass = args['screenClass'] as String;
    }

    // de-dupe: don’t log the same screen twice in a row
    final dedupeKey = '$screenName#$screenClass';
    if (_lastLoggedScreen == dedupeKey) {
      return;
    }
    _lastLoggedScreen = dedupeKey;

    // Let the frame settle to avoid edge cases during transitions
    await Future<void>.microtask(() {});

    _appNavigationObserver.logNavigation(
      screenName: screenName,
      screenClass: screenClass,
    );

    _logger.log(
      LogLevel.info,
      'Analytics screen_view: $screenName ($screenClass)',
    );
  }
}
