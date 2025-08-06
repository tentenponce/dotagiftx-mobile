import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/number_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/item_verification_icon_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/rarity_text_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class MyActiveListingItemView extends StatelessWidget {
  final MarketListingModel listing;

  const MyActiveListingItemView({required this.listing, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.darkGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Item Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: DotagiftxImageView(
                    imageUrl: listing.item?.image ?? '',
                    rarity: listing.item?.rarity ?? '',
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(width: 12),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              listing.item?.name ??
                                  I18n.of(
                                    context,
                                  ).myActiveListingItemViewUnknownItem,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ItemVerificationIconView(
                            status: listing.inventoryStatus,
                            isResell: listing.resell,
                            name: listing.user?.name,
                            createdAt: listing.createdAt,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            listing.item?.hero ?? '',
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          if (listing.item?.hero?.isNotEmpty ?? false)
                            const SizedBox(width: 4),
                          RarityTextView(rarity: listing.item?.rarity ?? ''),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Listed date
                      if (listing.createdAt != null)
                        Wrap(
                          spacing: 4,
                          children: [
                            Text(
                              I18n.of(
                                context,
                              ).myActiveListingItemViewListedDate,
                              style: const TextStyle(
                                color: AppColors.lightGreen,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              DateFormatUtils.formatDateAgo(listing.createdAt!),
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Price
                Text(
                  '\$${NumberFormatUtils.formatDecimal(listing.price, 2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
