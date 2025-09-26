import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/number_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostItemSelectedDotaItemView extends StatelessWidget {
  const PostItemSelectedDotaItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostItemCubit, PostItemState>(
      builder: (context, state) {
        return state.selectedItem != null
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DotagiftxImageView(
                  imageUrl: state.selectedItem?.image ?? '',
                  height: 100,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.selectedItem?.origin ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        StringUtils.capitalizeEachWord(
                          state.selectedItem?.rarity ?? '',
                        ),
                        style: TextStyle(
                          color:
                              RarityUtils.getRarityColor(
                                state.selectedItem?.rarity,
                              ) ??
                              Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            I18n.of(context).postItemViewSelectedItemStartingAt,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (state.selectedItem?.lowestAsk ?? 0) > 0
                                ? NumberFormatUtils.formatDecimal(
                                  state.selectedItem?.lowestAsk,
                                  2,
                                )
                                : I18n.of(
                                  context,
                                ).postItemViewSelectedItemNoStartingAt,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            I18n.of(
                              context,
                            ).postItemViewSelectedItemRequestToBuyAt,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (state.selectedItem?.highestBid ?? 0) > 0
                                ? NumberFormatUtils.formatDecimal(
                                  state.selectedItem?.highestBid,
                                  2,
                                )
                                : I18n.of(
                                  context,
                                ).postItemViewSelectedItemNoRequestToBuyAt,
                            style: const TextStyle(color: AppColors.tealAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
            : const SizedBox.shrink();
      },
    );
  }
}
