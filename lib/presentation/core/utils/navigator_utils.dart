import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:flutter/material.dart';

abstract final class NavigatorUtils {
  static final Map<PageName, Type> _owner = {};
  static final Logger _logger = getIt<Logger>();

  static RouteSettings buildRouteSettings(PageNamed page, {String? prefix}) {
    final name = '${prefix ?? ''}${page.pageName.name}';
    return RouteSettings(name: name, arguments: {'screenClass': name});
  }

  static Future<T?> push<T>(BuildContext context, PageNamed page) {
    // check if the page is claimed
    _claim(page.pageName, page.runtimeType);

    return Navigator.push(
      context,
      MaterialPageRoute(
        settings: buildRouteSettings(page),
        builder: (_) => page,
      ),
    );
  }

  static Future<T?> showPageDialog<T>(
    BuildContext context,
    PageNamed page, {
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    Color? barrierColor,
    String? barrierLabel,
    Offset? anchorPoint,
  }) {
    // no claim check in dialog, since dialog are being reused
    return showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      anchorPoint: anchorPoint,
      routeSettings: buildRouteSettings(page, prefix: 'dialog:'),
      builder: (ctx) {
        return page;
      },
    );
  }

  static Future<T?> showPageModalBottomSheet<T>(
    BuildContext context,
    PageNamed page, {
    Color backgroundColor = Colors.transparent,
    bool isScrollControlled = false,
  }) {
    // no claim check in bottom sheet, since bottom sheet are being reused
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      isScrollControlled: isScrollControlled,
      routeSettings: buildRouteSettings(page, prefix: 'bottom-sheet:'),
      builder: (ctx) {
        return page as Widget;
      },
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
  home('home'),
  postItem('post-item'),
  placeBuyOrder('place-buy-order'),
  contactSeller('contact-seller'),
  contactBuyer('contact-buyer'),
  dotaItemDetail('dota-item-detail'),
  myListings('my-listings'),
  myOrders('my-orders'),
  roadmap('roadmap'),

  // bottom sheets
  contactBuyerProfile('contact-buyer-profile'),
  contactSellerProfile('contact-seller-profile'),
  completedItemProfile('completed-item-profile'),
  cancelledItemProfile('cancelled-item-profile'),
  deliveredItemProfile('delivered-item-profile'),
  loginWebview('login-webview'),
  myActiveListingDialog('my-active-listing-dialog'),
  myOrderDetailDialog('my-order-detail-dialog'),
  reservedItemDialog('reserved-item-dialog'),

  // dialogs
  genericErrorDialog('generic-error-dialog'),
  apiErrorDialog('api-error-dialog'),
  logoutConfirmDialog('logout-confirm-dialog');

  final String name;

  const PageName(this.name);
}

mixin PageNamed on Widget {
  PageName get pageName;
}
