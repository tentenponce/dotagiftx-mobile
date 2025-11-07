import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_text_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostItemPriceField extends StatefulWidget {
  const PostItemPriceField({super.key});

  @override
  State<PostItemPriceField> createState() => _PostItemPriceFieldState();
}

class _PostItemPriceFieldState extends State<PostItemPriceField> {
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              I18n.of(context).postItemViewTextFieldPrice,
              style: AppTextStyles.defaultTextStyle(
                context,
              ).copyWith(fontSize: 16, fontWeight: FontWeight.w500),
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
        Row(
          children: [
            Expanded(
              child: BlocBuilder<PostItemCubit, PostItemState>(
                buildWhen:
                    (previous, current) =>
                        previous.isPriceErrorRequired !=
                        current.isPriceErrorRequired,
                builder: (context, state) {
                  return AppTextField(
                    controller: _priceController,
                    onChanged:
                        (value) => context.read<PostItemCubit>().price = value,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    maxLines: 1,
                    error:
                        state.isPriceErrorRequired
                            ? Text(
                              I18n.of(context).postItemViewPriceErrorRequired,
                              style: AppTextStyles.defaultTextStyle(
                                context,
                              ).copyWith(color: Colors.red),
                            )
                            : null,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          I18n.of(context).postItemViewTextFieldPriceDescription,
          style: AppTextStyles.defaultTextStyle(
            context,
          ).copyWith(color: AppColors.grey, fontSize: 12),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _priceController.text = context.read<PostItemCubit>().price;
  }
}
