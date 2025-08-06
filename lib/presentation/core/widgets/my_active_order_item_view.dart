import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/number_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/item_verification_icon_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/rarity_text_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class MyActiveOrderItemView extends StatelessWidget {
  final MarketListingModel order;

  const MyActiveOrderItemView({required this.order, super.key});

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
                    imageUrl: order.item?.image ?? '',
                    rarity: order.item?.rarity ?? '',
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
                              order.item?.name ??
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
                            status: order.inventoryStatus,
                            isResell: order.resell,
                            name: order.user?.name,
                            createdAt: order.createdAt,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            order.item?.hero ?? '',
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          if (order.item?.hero?.isNotEmpty ?? false)
                            const SizedBox(width: 4),
                          RarityTextView(rarity: order.item?.rarity ?? ''),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (!StringUtils.isNullOrEmpty(order.createdAt))
                        Wrap(
                          spacing: 4,
                          children: [
                            Text(
                              I18n.of(context).myActiveOrderItemViewOrderedDate,
                              style: const TextStyle(
                                color: AppColors.lightGreen,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              DateFormatUtils.formatDateAgo(order.createdAt!),
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
                  '\$${NumberFormatUtils.formatDecimal(order.price, 2)}',
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
