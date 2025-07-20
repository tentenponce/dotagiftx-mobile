import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/user_subscription_badge_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

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
            onPressed: () => {},
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
                user.name ?? 'Unknown User',
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
            ],
          ),
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
}
