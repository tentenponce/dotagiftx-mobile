import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NavigationModule {
  @lazySingleton
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();
}
