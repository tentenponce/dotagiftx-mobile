import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class MarketFilterButtonView extends StatelessWidget {
  final String label;
  final String filter;
  final String currentFilter;
  final VoidCallback onTap;

  const MarketFilterButtonView({
    required this.label,
    required this.filter,
    required this.currentFilter,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentFilter == filter;

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : Theme.of(context).colorScheme.surface,
        foregroundColor:
            isSelected
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.surface,
        side: const BorderSide(color: Color.fromRGBO(81, 81, 81, 1), width: 1),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      child: Text(
        label,
        style: AppTextStyles.defaultTextStyle(
          context,
        ).copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
