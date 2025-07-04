import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class RarityUtils {
  static Color? getRarityColor(String? rarity) {
    switch (rarity?.toLowerCase()) {
      case 'rare':
        return AppColors.rare;
      case 'ultra rare':
        return AppColors.ultraRare;
      case 'very rare':
        return AppColors.veryRare;
      case 'mythical':
        return AppColors.mythical;
      case 'immortal':
        return AppColors.immortal;
      default:
        return null;
    }
  }
}
