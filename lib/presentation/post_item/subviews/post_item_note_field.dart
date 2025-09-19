import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class PostItemNoteField extends StatefulWidget {
  const PostItemNoteField({super.key});

  @override
  State<PostItemNoteField> createState() => _PostItemNoteFieldState();
}

class _PostItemNoteFieldState extends State<PostItemNoteField> {
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                I18n.of(context).postItemViewTextFieldNotes,
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
                child: TextField(
                  controller: _notesController,
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
                      borderSide: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
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
            I18n.of(context).postItemViewTextFieldNotesDescription,
            style: const TextStyle(color: AppColors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
