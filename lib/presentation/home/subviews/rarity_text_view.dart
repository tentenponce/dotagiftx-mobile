import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
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

    final textColor = RarityUtils.getRarityColor(rarity) ?? Colors.white;

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
