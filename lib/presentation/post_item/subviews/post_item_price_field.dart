import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
                  return TextField(
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
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
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
                      error:
                          state.isPriceErrorRequired
                              ? Text(
                                I18n.of(context).postItemViewPriceErrorRequired,
                                style: const TextStyle(color: Colors.red),
                              )
                              : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          I18n.of(context).postItemViewTextFieldPriceDescription,
          style: const TextStyle(color: AppColors.grey, fontSize: 12),
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
