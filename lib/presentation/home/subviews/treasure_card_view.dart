import 'package:collection/collection.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/shared/assets/assets.gen.dart';
import 'package:flutter/material.dart';

class TreasureCard extends StatelessWidget {
  final TreasureModel treasure;

  const TreasureCard({required this.treasure, super.key});

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(
      color: RarityUtils.getRarityColor(treasure.rarity) ?? Colors.transparent,
      width: 1,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border(bottom: borderSide, left: borderSide, right: borderSide),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: borderSide,
                  left: borderSide,
                  right: borderSide,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child:
                    !StringUtils.isNullOrEmpty(treasure.imageUrl)
                        ? Image.network(treasure.imageUrl!, fit: BoxFit.cover)
                        : Assets.images.treasures.values
                            .firstWhereOrNull(
                              (element) => element.keyName.contains(
                                treasure.image ?? '',
                              ),
                            )
                            ?.image(
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return ColoredBox(
                                  color: AppColors.grey.withValues(alpha: 0.3),
                                  child: const Icon(
                                    Icons.inventory,
                                    color: AppColors.grey,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
              ),
            ),
          ),
          // Content
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Name
                  Text(
                    treasure.name ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
