import 'package:dotagiftx_mobile/domain/models/steam_user_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class ContactBuyerGuidelinesView extends StatelessWidget {
  final SteamUserModel steamUser;
  final void Function(String url, String title) onShowWebview;

  const ContactBuyerGuidelinesView({
    required this.steamUser,
    required this.onShowWebview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18n.of(context).contactBuyerViewGuidelinesTitle,
          style: AppTextStyles.defaultTextStyle(
            context,
          ).copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        _GuidelineItem(text: I18n.of(context).contactBuyerViewGuideline1),
        const SizedBox(height: 12),

        _GuidelineItem(text: I18n.of(context).contactBuyerViewGuideline2),
        const SizedBox(height: 12),

        _GuidelineItem(text: I18n.of(context).contactBuyerViewGuideline3),
        const SizedBox(height: 12),

        _GuidelineItem(text: I18n.of(context).contactBuyerViewGuideline4),
      ],
    );
  }
}

class _GuidelineItem extends StatelessWidget {
  final String text;

  const _GuidelineItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: AppTextStyles.defaultTextStyle(context).copyWith(fontSize: 14),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
