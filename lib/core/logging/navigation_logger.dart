import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract interface class NavigationLogger implements NavigatorObserver {
  String getPreviousRouteName();
}

@LazySingleton(as: NavigationLogger)
class NavigationLoggerImpl extends RouteObserver<ModalRoute<dynamic>>
    implements NavigationLogger {
  final Logger _logger;
  Route<dynamic>? _previousRoute;

  NavigationLoggerImpl(this._logger) {
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
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _previousRoute = previousRoute;
    _logger.log(
      LogLevel.info,
      '${_getRoutePath(previousRoute)} === PUSHED ==> ${_getRoutePath(route)}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _previousRoute = oldRoute;
    _logger.log(
      LogLevel.info,
      '${_getRoutePath(oldRoute)} === REPLACED ==> ${_getRoutePath(newRoute)}',
    );
  }

  @override
  String getPreviousRouteName() {
    return _getRoutePath(_previousRoute);
  }

  String _getRoutePath(Route<dynamic>? route) {
    final routeSettings = route?.settings;

    return routeSettings?.name ?? '';
  }
}
