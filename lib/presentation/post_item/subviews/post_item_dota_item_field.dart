import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_text_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PostItemDotaItemField extends StatefulWidget {
  final DotaItemModel? preselectDotaItem;

  const PostItemDotaItemField({super.key, this.preselectDotaItem});

  @override
  State<PostItemDotaItemField> createState() => _PostItemDotaItemFieldState();
}

class _PostItemDotaItemFieldState extends State<PostItemDotaItemField> {
  final FocusNode _itemSearchFocusNode = FocusNode();
  final TextEditingController _itemSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              I18n.of(context).postItemViewItemName,
              style: AppTextStyles.defaultTextStyle(
                context,
              ).copyWith(fontSize: 14),
            ),
            Text(
              ' *',
              style: AppTextStyles.defaultTextStyle(context).copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<PostItemCubit, PostItemState>(
              listenWhen:
                  (previous, current) =>
                      previous.selectedItem != current.selectedItem,
              listener: (context, state) {
                if (state.selectedItem != null) {
                  _itemSearchController.text =
                      '${state.selectedItem?.hero ?? 'Unknown'} - ${state.selectedItem?.name ?? 'Unknown'}';
                  _itemSearchFocusNode.unfocus();
                }
              },
              buildWhen:
                  (previous, current) =>
                      previous.isItemErrorRequired !=
                      current.isItemErrorRequired,
              builder:
                  (context, state) => AppTextField(
                    focusNode: _itemSearchFocusNode,
                    controller: _itemSearchController,
                    onChanged: context.read<PostItemCubit>().filterItems,
                    onTap: () {
                      if (_itemSearchController.text.isNotEmpty) {
                        context.read<PostItemCubit>().filterItems(
                          _itemSearchController.text,
                        );
                      }
                    },
                    hintText: I18n.of(context).postItemViewItemHint,
                    border: OutlineInputBorder(
                      borderRadius:
                          _itemSearchFocusNode.hasFocus
                              ? const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              )
                              : BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    error:
                        state.isItemErrorRequired &&
                                !_itemSearchFocusNode.hasFocus
                            ? Text(
                              I18n.of(context).postItemViewItemErrorRequired,
                              style: AppTextStyles.defaultTextStyle(
                                context,
                              ).copyWith(color: Colors.red),
                            )
                            : null,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              context.read<PostItemCubit>().clearSelectedItem();
                              _itemSearchController.clear();
                            },
                            child: const Icon(
                              Icons.clear,
                              color: AppColors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.grey,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
            ),
            _buildListDropdown(),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _itemSearchFocusNode.dispose();
    _itemSearchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.preselectDotaItem != null) {
      _itemSearchController.text =
          '${widget.preselectDotaItem?.hero ?? 'Unknown'} - ${widget.preselectDotaItem?.name ?? 'Unknown'}';
    }

    _itemSearchFocusNode.addListener(() {
      // trigger set state to rebuild the search item dropdown if not focus then hide dropdown
      setState(() {});
    });
  }

  Widget _buildListDropdown() {
    return BlocBuilder<PostItemCubit, PostItemState>(
      buildWhen:
          (previous, current) =>
              previous.items != current.items ||
              previous.isGetItemsLoading != current.isGetItemsLoading,
      builder: (context, state) {
        return _itemSearchFocusNode.hasFocus
            ? Container(
              constraints:
                  !state.isGetItemsLoading
                      ? const BoxConstraints(maxHeight: 200)
                      : null,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child:
                  state.isGetItemsLoading
                      ? Column(
                        children: [
                          _buildShimmerSuggestionItem(),
                          _buildShimmerSuggestionItem(),
                          _buildShimmerSuggestionItem(),
                          _buildShimmerSuggestionItem(end: true),
                        ],
                      )
                      : state.items.isEmpty
                      ? Center(
                        child: Text(
                          I18n.of(context).postItemViewItemNoResults,
                          style: AppTextStyles.defaultTextStyle(
                            context,
                          ).copyWith(color: AppColors.grey, fontSize: 14),
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return InkWell(
                            onTap:
                                () => context.read<PostItemCubit>().selectItem(
                                  item,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    index < state.items.length - 1
                                        ? Border(
                                          bottom: BorderSide(
                                            color: AppColors.grey.withValues(
                                              alpha: 0.2,
                                            ),
                                            width: 0.5,
                                          ),
                                        )
                                        : null,
                              ),
                              child: _buildSuggestionItem(item),
                            ),
                          );
                        },
                      ),
            )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerSuggestionItem({bool? end}) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surfaceContainer,
        highlightColor: AppColors.grey.withValues(alpha: 0.5),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius:
                (end ?? false)
                    ? const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                    : null,
          ),
          height: 40,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(DotaItemModel item) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.hero ?? 'Unknown'} - ${item.name ?? 'Unknown'}',
                style: AppTextStyles.defaultTextStyle(
                  context,
                ).copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              if (item.hero != null) ...[
                const SizedBox(height: 2),
                Text(
                  item.hero!,
                  style: AppTextStyles.defaultTextStyle(
                    context,
                  ).copyWith(color: AppColors.grey, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        if (item.rarity != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: RarityUtils.getRarityColor(item.rarity),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.rarity!,
              style: AppTextStyles.defaultTextStyle(
                context,
              ).copyWith(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}
