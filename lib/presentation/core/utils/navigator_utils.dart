import 'package:dotagiftx_mobile/presentation/core/base/base_page_widget.dart';
import 'package:flutter/material.dart';

abstract final class NavigatorUtils {
  static final Map<PageName, Type> _owner = {};

  static Future<T?> push<T>(BuildContext context, BasePageWidget page) {
    assert(
      () {
        _claim(page.pageName, page.runtimeType);
        return true;
      }(),
      'PageName ${page.pageName} already claimed by ${_owner[page.pageName]}; cannot assign to ${page.runtimeType}.',
    );

    return Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: page.pageName.name),
        builder: (_) => page,
      ),
    );
  }

  static void _claim(PageName pageName, Type type) {
    final existing = _owner[pageName];
    if (existing != null && existing != type) {
      throw FlutterError(
        'PageName "$pageName" already claimed by $existing; cannot assign to $type.',
      );
    }
    _owner[pageName] = type;
  }
}

enum PageName {
  postItem('post-item'),
  placeBuyOrder('place-buy-order');

  final String name;

  const PageName(this.name);
}
