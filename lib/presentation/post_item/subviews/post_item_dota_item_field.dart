import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostItemDotaItemField extends StatefulWidget {
  const PostItemDotaItemField({super.key});

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
        Text(
          I18n.of(context).postItemViewItemName,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              BlocListener<PostItemCubit, PostItemState>(
                listener: (context, state) {
                  if (state.selectedItem != null) {
                    _itemSearchController.text =
                        '${state.selectedItem?.hero ?? 'Unknown'} - ${state.selectedItem?.name ?? 'Unknown'}';
                  }
                },
                child: TextField(
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: I18n.of(context).postItemViewItemHint,
                    hintStyle: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.darkGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ),
              _buildListDropdown(),
            ],
          ),
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

    _itemSearchFocusNode.addListener(() {
      // trigger set state to rebuild the search item dropdown if not focus then hide dropdown
      setState(() {});
    });
  }

  Widget _buildListDropdown() {
    return BlocBuilder<PostItemCubit, PostItemState>(
      buildWhen:
          (previous, current) =>
              previous.showDropdown != current.showDropdown ||
              previous.items != current.items,
      builder: (context, state) {
        return state.showDropdown && _itemSearchFocusNode.hasFocus
            ? Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return InkWell(
                    onTap: () => context.read<PostItemCubit>().selectItem(item),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.hero ?? 'Unknown'} - ${item.name ?? 'Unknown'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (item.hero != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item.hero!,
                                    style: const TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (item.rarity != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: RarityUtils.getRarityColor(item.rarity),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.rarity!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
            : const SizedBox.shrink();
      },
    );
  }
}
