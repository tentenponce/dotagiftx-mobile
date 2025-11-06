import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_text_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostItemQuantityField extends StatefulWidget {
  const PostItemQuantityField({super.key});

  @override
  State<PostItemQuantityField> createState() => _PostItemQuantityFieldState();
}

class _PostItemQuantityFieldState extends State<PostItemQuantityField> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18n.of(context).postItemViewTextFieldQuantity,
          style: AppTextStyles.defaultTextStyle(
            context,
          ).copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          onChanged: (value) => context.read<PostItemCubit>().quantity = value,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _quantityController.text = context.read<PostItemCubit>().quantity;
    context.read<PostItemCubit>().setQuantity = (quantity) {
      _quantityController.text = quantity.toString();
    };
  }
}
