import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_text_field.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/viewmodels/place_buy_order_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceBuyOrderNoteField extends StatefulWidget {
  const PlaceBuyOrderNoteField({super.key});

  @override
  State<PlaceBuyOrderNoteField> createState() => _PlaceBuyOrderNoteFieldState();
}

class _PlaceBuyOrderNoteFieldState extends State<PlaceBuyOrderNoteField> {
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18n.of(context).placeBuyOrderTextFieldNotes,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _notesController,
                  onChanged:
                      (value) =>
                          context.read<PlaceBuyOrderCubit>().notes = value,
                  maxLines: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            I18n.of(context).placeBuyOrderTextFieldNotesDescription,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(color: AppColors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _notesController.text = context.read<PlaceBuyOrderCubit>().notes;
  }
}
