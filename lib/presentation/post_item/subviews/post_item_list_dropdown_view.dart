import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostItemListDropdownView extends StatelessWidget {
  final FocusNode itemSearchFocusNode;
  const PostItemListDropdownView({
    required this.itemSearchFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostItemCubit, PostItemState>(
      buildWhen:
          (previous, current) =>
              previous.showDropdown != current.showDropdown ||
              previous.items != current.items,
      builder: (context, state) {
        return state.showDropdown && itemSearchFocusNode.hasFocus
            ? Container(
              constraints: BoxConstraints(maxHeight: 200.h),
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
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
                                  SizedBox(height: 2.h),
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: RarityUtils.getRarityColor(item.rarity),
                                borderRadius: BorderRadius.circular(4.r),
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
