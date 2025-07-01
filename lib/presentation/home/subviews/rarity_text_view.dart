import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
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
        textColor = const Color.fromRGBO(142, 192, 33, 1); // rgb(142, 192, 33)
      case 'ultra rare':
        textColor = const Color.fromRGBO(226, 172, 63, 1); // rgb(226, 172, 63)
      case 'very rare':
        textColor = const Color.fromRGBO(251, 134, 0, 1); // rgb(251, 134, 0)
      default:
        // For any other rarity, use a default gray color
        textColor = Colors.grey[400]!;
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
