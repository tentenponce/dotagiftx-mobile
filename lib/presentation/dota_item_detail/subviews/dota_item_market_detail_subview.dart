import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:flutter/material.dart';

class DotaItemMarketDetailSubview extends StatelessWidget {
  final DotaItemModel item;

  const DotaItemMarketDetailSubview({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final rarityColor =
        RarityUtils.getRarityColor(item.rarity) ?? AppColors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Item Image Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: DotagiftxImageView(
                imageUrl: item.image ?? '',
                rarity: item.rarity ?? '',
                width: double.infinity,
                height: 300,
                borderWidth: 6,
              ),
            ),
          ),
        ),

        // Item Details Section
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collection/Source Info
              Text(
                _getItemSource(),
                style: TextStyle(
                  color: rarityColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Hero Info
              Row(
                children: [
                  const Text(
                    'Hero: ',
                    style: TextStyle(color: AppColors.grey, fontSize: 16),
                  ),
                  Text(
                    item.hero ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats Row
              Text(
                '• ${item.reservedCount} Reserved • ${item.soldCount} Delivered',
                style: const TextStyle(color: AppColors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getItemSource() {
    final rarity = item.rarity ?? '';
    // This is a placeholder - you might want to get actual source/collection info
    return "${item.origin} — ${rarity.isNotEmpty ? rarity.substring(0, 1).toUpperCase() + rarity.substring(1) : ''}";
  }
}
