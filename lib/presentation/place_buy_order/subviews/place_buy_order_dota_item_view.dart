import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/number_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlaceBuyOrderDotaItemView extends StatelessWidget {
  final DotaItemModel item;
  const PlaceBuyOrderDotaItemView({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DotagiftxImageView(imageUrl: item.image ?? '', height: 100),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.origin ?? '',
                style: AppTextStyles.defaultTextStyle(context),
              ),
              const SizedBox(height: 4),
              Text(
                StringUtils.capitalizeEachWord(item.rarity ?? ''),
                style: AppTextStyles.defaultTextStyle(context).copyWith(
                  color:
                      RarityUtils.getRarityColor(item.rarity) ??
                      Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    I18n.of(context).playBuyOrderDotaItemViewLowestPrice,
                    style: AppTextStyles.defaultTextStyle(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    (item.lowestAsk ?? 0) > 0
                        ? NumberFormatUtils.formatDecimal(item.lowestAsk, 2)
                        : I18n.of(
                          context,
                        ).playBuyOrderDotaItemViewNoLowestPrice,
                    style: AppTextStyles.defaultTextStyle(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
