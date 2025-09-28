import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:flutter/material.dart';

abstract final class NavigatorUtils {
  static final Map<PageName, Type> _owner = {};
  static final Logger _logger = getIt<Logger>();

  static Future<T?> push<T>(BuildContext context, PageNamed page) {
    // check if the page is claimed
    _claim(page.pageName, page.runtimeType);

    return Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(
          name: page.pageName.name,
          arguments: {'screenClass': page.runtimeType.toString()},
        ),
        builder: (_) => page,
      ),
    );
  }

  static void _claim(PageName pageName, Type type) {
    final existing = _owner[pageName];
    if (existing != null && existing != type) {
      _logger.log(
        LogLevel.error,
        'PageName "$pageName" already claimed by $existing; cannot assign to $type.',
      );
    }
    _owner[pageName] = type;
  }
}

enum PageName {
  postItem('post-item'),
  placeBuyOrder('place-buy-order'),
  contactSeller('contact-seller'),
  contactBuyer('contact-buyer'),
  dotaItemDetail('dota-item-detail'),
  myListings('my-listings'),
  myOrders('my-orders'),
  roadmap('roadmap');

  final String name;

  const PageName(this.name);
}

mixin PageNamed on Widget {
  PageName get pageName;
}
