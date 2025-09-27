import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/steam_user_model.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ContactSellerGuidelinesView extends StatelessWidget {
  final SteamUserModel steamUser;
  final void Function(String url, String title) onShowWebview;

  const ContactSellerGuidelinesView({
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
          I18n.of(context).contactSellerViewGuidelinesTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        _buildGuidelineItem([
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline1Prefix,
          ),
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline1LinkText,
            isLink: true,
            onTap:
                () => onShowWebview(
                  RemoteConfigConstants.defaultSteamInventoryUrl(
                    steamUser.steamId ?? '',
                  ),
                  I18n.of(context).guidelinesWebviewTitleInventory,
                ),
          ),
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline1Suffix,
          ),
        ]),
        const SizedBox(height: 12),

        _buildGuidelineItem([
          _TextSegment(text: I18n.of(context).contactSellerViewGuideline2),
        ]),
        const SizedBox(height: 12),

        _GuidelineItem(text: I18n.of(context).contactSellerViewGuideline3),
        const SizedBox(height: 12),

        _buildGuidelineItem([
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline4Prefix,
          ),
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline4LinkText1,
            isLink: true,
            onTap:
                () => onShowWebview(
                  RemoteConfigConstants.defaultSteamRepUrl(
                    steamUser.steamId ?? '',
                  ),
                  I18n.of(context).guidelinesWebviewTitleSteamRep,
                ),
          ),
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline4Middle,
          ),
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline4LinkText2,
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
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline4Suffix,
          ),
        ]),
        const SizedBox(height: 12),

        _buildGuidelineItem([
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline5Prefix,
          ),
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline5LinkText,
            isLink: true,
            onTap:
                () => onShowWebview(
                  RemoteConfigConstants.defaultMiddlemanUrl,
                  I18n.of(context).guidelinesWebviewTitleMiddleman,
                ),
          ),
          _TextSegment(
            text: I18n.of(context).contactSellerViewGuideline5Suffix,
          ),
        ]),
      ],
    );
  }

  Widget _buildGuidelineItem(List<_TextSegment> segments) {
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

class _TextSegment {
  final String text;
  final bool isLink;
  final VoidCallback? onTap;

  const _TextSegment({required this.text, this.isLink = false, this.onTap});
}
