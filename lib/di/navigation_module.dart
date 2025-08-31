import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NavigationModule {
  @lazySingleton
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();
}
