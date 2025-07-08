import 'package:dotagiftx_mobile/data/core/constants/user_subscription_constants.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class UserSubscriptionBadgeView extends StatelessWidget {
  final int? subscription;

  const UserSubscriptionBadgeView({required this.subscription, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getBadgeColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getUserBadge(context),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color? _getBadgeColor() {
    switch (subscription) {
      case UserSubscriptionConstants.supporter:
        return const Color(0xFF596B95);
      case UserSubscriptionConstants.trader:
        return const Color(0xFF629CBD);
      case UserSubscriptionConstants.partner:
        return const Color(0xFFC79123);
      default:
        return null;
    }
  }

  String _getUserBadge(BuildContext context) {
    switch (subscription) {
      case UserSubscriptionConstants.supporter:
        return I18n.of(context).userSubscriptionBadgeSupporter;
      case UserSubscriptionConstants.trader:
        return I18n.of(context).userSubscriptionBadgeTrader;
      case UserSubscriptionConstants.partner:
        return I18n.of(context).userSubscriptionBadgePartner;
      default:
        return '';
    }
  }
}
