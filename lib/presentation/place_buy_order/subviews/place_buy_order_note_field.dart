import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _notesController,
                  onChanged:
                      (value) =>
                          context.read<PlaceBuyOrderCubit>().notes = value,
                  maxLines: 4,
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
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            I18n.of(context).placeBuyOrderTextFieldNotesDescription,
            style: const TextStyle(color: AppColors.grey, fontSize: 12),
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
