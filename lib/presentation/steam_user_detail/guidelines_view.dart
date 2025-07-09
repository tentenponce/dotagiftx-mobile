import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/steam_user_model.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GuidelinesView extends StatelessWidget {
  final SteamUserModel steamUser;
  final void Function(String url, String title) onShowWebview;

  const GuidelinesView({
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
          I18n.of(context).steamUserDetailGuidelinesTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        _buildGuidelineItem([
          TextSegment(text: I18n.of(context).steamUserDetailGuideline1Prefix),
          TextSegment(
            text: I18n.of(context).steamUserDetailGuideline1LinkText,
            isLink: true,
            onTap:
                () => onShowWebview(
                  RemoteConfigConstants.defaultSteamInventoryUrl(
                    steamUser.steamId ?? '',
                  ),
                  I18n.of(context).guidelinesWebviewTitleInventory,
                ),
          ),
          TextSegment(text: I18n.of(context).steamUserDetailGuideline1Suffix),
        ]),
        const SizedBox(height: 12),

        _buildGuidelineItem([
          TextSegment(text: I18n.of(context).steamUserDetailGuideline2),
        ]),
        const SizedBox(height: 12),

        _GuidelineItem(text: I18n.of(context).steamUserDetailGuideline3),
        const SizedBox(height: 12),

        _buildGuidelineItem([
          TextSegment(text: I18n.of(context).steamUserDetailGuideline4Prefix),
          TextSegment(
            text: I18n.of(context).steamUserDetailGuideline4LinkText1,
            isLink: true,
            onTap:
                () => onShowWebview(
                  RemoteConfigConstants.defaultSteamRepUrl(
                    steamUser.steamId ?? '',
                  ),
                  I18n.of(context).guidelinesWebviewTitleSteamRep,
                ),
          ),
          TextSegment(text: I18n.of(context).steamUserDetailGuideline4Middle),
          TextSegment(
            text: I18n.of(context).steamUserDetailGuideline4LinkText2,
            isLink: true,
            onTap: () {
              onShowWebview(
                RemoteConfigConstants.defaultTransactionHistoryUrl(
                  steamUser.steamId ?? '',
                ),
                I18n.of(context).guidelinesWebviewTitleTransactionHistory,
              );
            },
          ),
          TextSegment(text: I18n.of(context).steamUserDetailGuideline4Suffix),
        ]),
        const SizedBox(height: 12),

        _buildGuidelineItem([
          TextSegment(text: I18n.of(context).steamUserDetailGuideline5Prefix),
          TextSegment(
            text: I18n.of(context).steamUserDetailGuideline5LinkText,
            isLink: true,
            onTap:
                () => onShowWebview(
                  RemoteConfigConstants.defaultMiddlemanUrl,
                  I18n.of(context).guidelinesWebviewTitleMiddleman,
                ),
          ),
          TextSegment(text: I18n.of(context).steamUserDetailGuideline5Suffix),
        ]),
      ],
    );
  }

  Widget _buildGuidelineItem(List<TextSegment> segments) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: Colors.white, fontSize: 14)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              children:
                  segments.map((segment) {
                    if (segment.isLink) {
                      return TextSpan(
                        text: segment.text,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                            segment.onTap != null
                                ? (TapGestureRecognizer()
                                  ..onTap = segment.onTap)
                                : null,
                      );
                    } else {
                      return TextSpan(text: segment.text);
                    }
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class TextSegment {
  final String text;
  final bool isLink;
  final VoidCallback? onTap;

  const TextSegment({required this.text, this.isLink = false, this.onTap});
}

class _GuidelineItem extends StatelessWidget {
  final String text;

  const _GuidelineItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: Colors.white, fontSize: 14)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
