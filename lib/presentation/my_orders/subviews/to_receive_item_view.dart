import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/number_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/item_verification_icon_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/rarity_text_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class ToReceiveItemView extends StatelessWidget {
  final MarketListingModel listing;
  const ToReceiveItemView({required this.listing, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
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
                                  I18n.of(context).reservedItemViewUnknownItem,
                              style: AppTextStyles.defaultTextStyle(
                                context,
                              ).copyWith(
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
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(color: AppColors.grey, fontSize: 14),
                          ),
                          if (listing.item?.hero?.isNotEmpty ?? false)
                            const SizedBox(width: 4),
                          RarityTextView(rarity: listing.item?.rarity ?? ''),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            I18n.of(context).toReceiveItemViewReserved,
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(color: AppColors.purple, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            I18n.of(context).toReceiveItemViewReservedFrom,
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(color: AppColors.grey, fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          DotagiftxImageView(
                            imageUrl: listing.user?.avatar ?? '',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            listing.user?.name ??
                                I18n.of(context).toReceiveItemViewUnknown,
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatUtils.formatDateAgo(
                              listing.updatedAt ?? '',
                            ),
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(color: AppColors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // notes
                      if (!StringUtils.isNullOrEmpty(listing.notes))
                        Text(
                          listing.notes!,
                          style: AppTextStyles.defaultTextStyle(
                            context,
                          ).copyWith(
                            color: AppColors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Price
                Text(
                  '\$${NumberFormatUtils.formatDecimal(listing.price, 2)}',
                  style: AppTextStyles.defaultTextStyle(context).copyWith(
                    color: Theme.of(context).colorScheme.primary,
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
