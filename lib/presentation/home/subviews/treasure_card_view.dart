import 'package:collection/collection.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/shared/assets/assets.gen.dart';
import 'package:flutter/material.dart';

class TreasureCardView extends StatelessWidget {
  final TreasureModel treasure;
  final VoidCallback? onTap;

  const TreasureCardView({required this.treasure, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final borderSide = BorderSide(
      color: RarityUtils.getRarityColor(treasure.rarity) ?? Colors.transparent,
      width: 1,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // Card content (background)
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                bottom: borderSide,
                left: borderSide,
                right: borderSide,
              ),
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
                          Assets.images.treasures.values
                              .firstWhereOrNull(
                                (element) => element.keyName.contains(
                                  treasure.image ?? '',
                                ),
                              )
                              ?.image(
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _brokenImage(context);
                                },
                              ) ??
                          (!StringUtils.isNullOrEmpty(treasure.imageUrl)
                              ? Image.network(
                                treasure.imageUrl!,
                                fit: BoxFit.cover,
                              )
                              : _brokenImage(context)),
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
                          style: AppTextStyles.defaultTextStyle(
                            context,
                          ).copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // InkWell overlay (foreground)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _brokenImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.surfaceDim.withValues(alpha: 0.3),
      child: Icon(Icons.broken_image, color: colorScheme.onSurface, size: 40),
    );
  }
}
