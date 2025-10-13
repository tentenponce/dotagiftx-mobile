import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/contact_seller/contact_seller_view.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/item_verification_icon_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/user_subscription_badge_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class MarketOfferCardView extends StatelessWidget {
  final MarketListingModel offer;

  const MarketOfferCardView({required this.offer, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Card content (background)
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
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
                                  style: AppTextStyles.defaultTextStyle(
                                    context,
                                  ).copyWith(
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
                                style: AppTextStyles.defaultTextStyle(
                                  context,
                                ).copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Verification Checkmark
                              ItemVerificationIconView(
                                status: offer.inventoryStatus,
                                isResell: offer.resell,
                                name: offer.user?.name,
                                createdAt: offer.createdAt,
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
                      style: AppTextStyles.defaultTextStyle(context).copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
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
                  onTap: () => _navigateToContactUser(context),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToContactUser(BuildContext context) {
    if (offer.user != null) {
      unawaited(
        NavigatorUtils.push(context, ContactSellerView(steamUser: offer.user!)),
      );
    }
  }
}
