import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? showClearButton;
  final int? maxLines;
  final bool? enabled;
  final Widget? error;
  final void Function()? onClear;

  const AppTextField({
    this.controller,
    this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton,
    this.error,
    this.onClear,
    this.maxLines,
    this.enabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.defaultTextStyle(context).copyWith(
          color:
              enabled == false
                  ? AppColors.grey.withValues(alpha: 0.5)
                  : AppColors.grey,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: enabled ?? true,
        fillColor:
            enabled == false
                ? AppColors.darkGrey.withValues(alpha: 0.5)
                : Theme.of(context).colorScheme.surfaceContainer,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        error: error,
      ),
      style: AppTextStyles.defaultTextStyle(context).copyWith(
        color: enabled == false ? AppColors.grey.withValues(alpha: 0.5) : null,
      ),
    );
  }
}
