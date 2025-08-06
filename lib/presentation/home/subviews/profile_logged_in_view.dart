import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/user_subscription_badge_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/my_listings_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/my_orders_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:dotagiftx_mobile/presentation/transaction_history/transaction_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileLoggedInView extends StatelessWidget {
  final UserModel user;

  const ProfileLoggedInView({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(I18n.of(context).profileLoggedInTitle),
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.black,
        actions: [
          OutlinedButton(
            onPressed: () {
              unawaited(_showLogoutConfirmationDialog(context));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.dirtyWhite,
              side: const BorderSide(color: AppColors.dirtyWhite),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              I18n.of(context).profileLoggedInLogoutButton,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DotagiftxImageView(
                imageUrl:
                    !StringUtils.isNullOrEmpty(user.avatar) ? user.avatar! : '',
                width: 120,
                height: 120,
                errorWidget: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.grey,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                user.name ?? I18n.of(context).profileNavUnknownUser,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 8),

              // Badge
              if (user.subscription != null && user.subscription != 0)
                UserSubscriptionBadgeView(
                  subscription: user.subscription,
                  fontSize: 14,
                )
              else
                const SizedBox.shrink(),
              const SizedBox(height: 8),

              // Join Date
              Text(
                I18n.of(context).steamUserDetailJoinedDate(
                  DateFormatUtils.formatDateAgo(user.createdAt ?? ''),
                ),
                style: const TextStyle(color: AppColors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),

              // Stats Row
              Text(
                _buildStatsText(context),
                style: const TextStyle(color: AppColors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              _buildButton(
                context,
                I18n.of(context).profileLoggedInMyListingsButton,
                CupertinoIcons.square_list,
                const MyListingsView(),
              ),
              const SizedBox(height: 12),
              _buildButton(
                context,
                I18n.of(context).profileLoggedInMyOrdersButton,
                CupertinoIcons.cube_box,
                const MyOrdersView(),
              ),
              const SizedBox(height: 12),
              _buildButton(
                context,
                I18n.of(context).profileLoggedInTransactionHistoryButton,
                CupertinoIcons.time,
                const TransactionHistoryView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    Widget page,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 72,
      child: OutlinedButton.icon(
        onPressed: () {
          unawaited(
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.dirtyWhite,
          side: const BorderSide(color: AppColors.dirtyWhite),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  String _buildStatsText(BuildContext context) {
    final stats = user.marketStats;

    return I18n.of(context).steamUserDetailStats(
      stats.live,
      stats.reserved,
      stats.sold,
      stats.bidCompleted,
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext buildContext) {
    return showDialog<void>(
      context: buildContext,
      builder:
          (context) => AlertDialog(
            title: Text(
              I18n.of(context).profileLoggedInLogoutConfirmTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              I18n.of(context).profileLoggedInLogoutConfirmMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: AppColors.black,
            titleTextStyle: const TextStyle(color: Colors.white),
            contentTextStyle: const TextStyle(color: Colors.white),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  I18n.of(context).profileLoggedInLogoutConfirmCancelButton,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  unawaited(
                    buildContext.read<HomeCubit>().profileCubit.logout(),
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  I18n.of(context).profileLoggedInLogoutConfirmLogoutButton,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
