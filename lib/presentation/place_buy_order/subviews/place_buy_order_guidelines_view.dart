import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlaceBuyOrderGuidelinesView extends StatelessWidget {
  const PlaceBuyOrderGuidelinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18n.of(context).placeBuyOrderViewGuidelinesTitle,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildGuideItem(
            context,
            I18n.of(context).placeBuyOrderViewGuideline1,
          ),
          _buildGuideItem(
            context,
            I18n.of(context).placeBuyOrderViewGuideline2,
          ),
          _buildGuideItem(
            context,
            I18n.of(context).placeBuyOrderViewGuideline3,
          ),
          _buildGuideItem(
            context,
            I18n.of(context).placeBuyOrderViewGuideline4,
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.defaultTextStyle(context).copyWith(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
