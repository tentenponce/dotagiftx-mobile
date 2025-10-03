import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? showClearButton;
  final void Function()? onClear;

  const AppTextField({
    this.controller,
    this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton,
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }
}
