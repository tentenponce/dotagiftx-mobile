import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/user_subscription_badge_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/item_verification_icon_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:dotagiftx_mobile/presentation/steam_user_detail/steam_user_detail_view.dart';
import 'package:flutter/material.dart';

class MarketOfferCardView extends StatelessWidget {
  final MarketListingModel offer;

  const MarketOfferCardView({required this.offer, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Card content (background)
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // User Avatar
                    DotagiftxImageView(
                      imageUrl:
                          !StringUtils.isNullOrEmpty(offer.user?.avatar)
                              ? offer.user!.avatar!
                              : '',
                      width: 48,
                      height: 48,
                      errorWidget: Container(
                        width: 48,
                        height: 48,
                        color: AppColors.grey.withValues(alpha: 0.3),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // User Info and Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Name Row
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                ),
                                child: Text(
                                  offer.user?.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // User Badge
                              UserSubscriptionBadgeView(
                                subscription: offer.user?.subscription,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Posted Date
                          Row(
                            children: [
                              Text(
                                !StringUtils.isNullOrEmpty(offer.createdAt)
                                    ? I18n.of(
                                      context,
                                    ).marketOfferCardPostedDate(
                                      DateFormatUtils.formatDateAgo(
                                        offer.createdAt!,
                                      ),
                                    )
                                    : '',
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Verification Checkmark
                              ItemVerificationIconView(
                                status: offer.inventoryStatus,
                                isResell: offer.resell,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Price
                    Text(
                      '\$${offer.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // InkWell overlay (foreground)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _navigateToSteamUserDetail(context),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSteamUserDetail(BuildContext context) {
    if (offer.user != null) {
      unawaited(
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SteamUserDetailView(steamUser: offer.user!),
          ),
        ),
      );
    }
  }
}
