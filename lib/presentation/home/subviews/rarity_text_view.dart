import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class RarityTextView extends StatelessWidget {
  final String rarity;
  final double fontSize;
  final FontWeight fontWeight;

  const RarityTextView({
    required this.rarity,
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    final rarityLower = rarity.toLowerCase();

    // Hide text completely for normal rarity
    if (rarityLower == 'regular') {
      return const SizedBox.shrink();
    }

    Color textColor;

    switch (rarityLower) {
      case 'rare':
        textColor = AppColors.rare;
      case 'ultra rare':
        textColor = AppColors.ultraRare;
      case 'very rare':
        textColor = AppColors.veryRare;
      default:
        // For any other rarity, use a default gray color
        textColor = Colors.white;
    }

    return Text(
      StringUtils.capitalizeEachWord(rarity),
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
