import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_outline_button.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/user_subscription_badge_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/logout_dialog.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/my_listings_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/my_orders_view.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/roadmap_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileLoggedInView extends StatefulWidget {
  final UserModel user;

  const ProfileLoggedInView({required this.user, super.key});

  @override
  State<ProfileLoggedInView> createState() => _ProfileLoggedInViewState();
}

class _ProfileLoggedInViewState extends State<ProfileLoggedInView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = colorScheme.surface;
    final fgColor = colorScheme.onSurface;
    final primary = colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          I18n.of(context).profileLoggedInTitle,
          style: AppTextStyles.defaultTextStyle(context),
        ),
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        scrolledUnderElevation: 0,
        surfaceTintColor: bgColor,
        actions: [
          AppOutlineButton(
            onPressed: () {
              unawaited(_showLogoutConfirmationDialog(context));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              side: BorderSide(color: primary),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              I18n.of(context).profileLoggedInLogoutButton,
              style: AppTextStyles.defaultTextStyle(
                context,
              ).copyWith(fontSize: 14, fontWeight: FontWeight.w500),
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
                    !StringUtils.isNullOrEmpty(widget.user.avatar)
                        ? widget.user.avatar!
                        : '',
                width: 120,
                height: 120,
                errorWidget: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceDim.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onSurface,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                widget.user.name ?? I18n.of(context).profileNavUnknownUser,
                style: AppTextStyles.defaultTextStyle(
                  context,
                ).copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 8),

              // Badge
              if (widget.user.subscription != null &&
                  widget.user.subscription != 0)
                UserSubscriptionBadgeView(
                  subscription: widget.user.subscription,
                  fontSize: 14,
                )
              else
                const SizedBox.shrink(),
              const SizedBox(height: 8),

              // Join Date
              Text(
                I18n.of(context).profileLoggedInJoinedDate(
                  DateFormatUtils.formatDateAgo(widget.user.createdAt ?? ''),
                ),
                style: AppTextStyles.defaultTextStyle(
                  context,
                ).copyWith(fontSize: 14),
              ),
              const SizedBox(height: 12),

              // Stats Row
              Text(
                _buildStatsText(context),
                style: AppTextStyles.defaultTextStyle(
                  context,
                ).copyWith(fontSize: 14),
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
                I18n.of(context).profileLoggedInRoadmapButton,
                CupertinoIcons.lightbulb,
                const RoadmapView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<HomeCubit>().profileCubit.initProfileLoggedInView();
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    PageNamed page,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 72,
      child: ElevatedButton.icon(
        onPressed: () {
          unawaited(NavigatorUtils.push(context, page));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainer,
          foregroundColor: colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: AppTextStyles.defaultTextStyle(
            context,
          ).copyWith(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  String _buildStatsText(BuildContext context) {
    final stats = widget.user.marketStats;

    return I18n.of(context).profileLoggedInStats(
      stats.live,
      stats.reserved,
      stats.sold,
      stats.bidCompleted,
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext buildContext) {
    return NavigatorUtils.showPageDialog<void>(
      buildContext,
      LogoutDialog(
        onLogout: () {
          unawaited(context.read<HomeCubit>().profileCubit.logout());
        },
      ),
    );
  }
}
