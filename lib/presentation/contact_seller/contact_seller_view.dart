import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/steam_user_model.dart';
import 'package:dotagiftx_mobile/presentation/contact_seller/subviews/contact_seller_guidelines_view.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateful_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_elevated_button.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/user_detail_webview_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/user_subscription_badge_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class ContactSellerView extends BasePageStatefulWidget {
  final SteamUserModel steamUser;

  const ContactSellerView({required this.steamUser, super.key})
    : super(pageName: PageName.contactSeller);

  @override
  State<ContactSellerView> createState() => _ContactSellerViewState();
}

class _ContactSellerViewState extends State<ContactSellerView> {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBody: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        scrolledUnderElevation: 0,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          I18n.of(context).contactSellerViewTitle,
          style: AppTextStyles.defaultTextStyle(
            context,
          ).copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          AppElevatedButton(
            onPressed:
                () => _showWebviewBottomSheet(
                  widget.steamUser.url ?? '',
                  I18n.of(context).contactSellerViewSteamProfileButton,
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              I18n.of(context).contactSellerViewSteamProfileButton,
              style: AppTextStyles.defaultTextStyle(context).copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        top: false, // App bar handles the top area
        bottom: true, // Ensure content respects navigation bar
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Section
                  _buildUserInfoSection(),
                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtonsRow(),
                  const SizedBox(height: 32),

                  // Guidelines Section
                  ContactSellerGuidelinesView(
                    steamUser: widget.steamUser,
                    onShowWebview: _showWebviewBottomSheet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return AppElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: AppTextStyles.defaultTextStyle(
          context,
        ).copyWith(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildActionButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          I18n.of(context).contactSellerViewSteamInventoryButton,
          () => _showWebviewBottomSheet(
            RemoteConfigConstants.defaultSteamInventoryUrl(
              widget.steamUser.steamId ?? '',
            ),
            I18n.of(context).contactSellerViewSteamInventoryButton,
          ),
        ),
        _buildActionButton(
          I18n.of(context).contactSellerViewSteamRepButton,
          () => _showWebviewBottomSheet(
            RemoteConfigConstants.defaultSteamRepUrl(
              widget.steamUser.steamId ?? '',
            ),
            I18n.of(context).contactSellerViewSteamRepButton,
          ),
        ),
        _buildActionButton(
          I18n.of(context).contactSellerViewDotabuffButton,
          () => _showWebviewBottomSheet(
            RemoteConfigConstants.defaultDotabuffUrl(
              widget.steamUser.steamId ?? '',
            ),
            I18n.of(context).contactSellerViewDotabuffButton,
          ),
        ),
      ],
    );
  }

  String _buildStatsText() {
    final stats = widget.steamUser.marketStats;
    if (stats == null) {
      return I18n.of(context).contactSellerViewStats(0, 0, 0, 0);
    }

    return I18n.of(context).contactSellerViewStats(
      stats.live ?? 0,
      stats.reserved ?? 0,
      stats.sold ?? 0,
      stats.bidCompleted ?? 0,
    );
  }

  Widget _buildUserInfoSection() {
    return Center(
      child: Column(
        children: [
          // User Avatar
          DotagiftxImageView(
            imageUrl:
                !StringUtils.isNullOrEmpty(widget.steamUser.avatar)
                    ? widget.steamUser.avatar!
                    : '',
            width: 120,
            height: 120,
            errorWidget: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: AppColors.grey, size: 60),
            ),
          ),
          const SizedBox(height: 16),

          // User Name
          Text(
            widget.steamUser.name ??
                I18n.of(context).contactSellerViewUnknownUser,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 8),

          // Badge
          if (widget.steamUser.subscription != null &&
              widget.steamUser.subscription != 0)
            UserSubscriptionBadgeView(
              subscription: widget.steamUser.subscription,
              fontSize: 14,
            )
          else
            const SizedBox.shrink(),
          const SizedBox(height: 8),

          // Join Date
          Text(
            I18n.of(context).contactSellerViewJoinedDate(
              DateFormatUtils.formatDateAgo(widget.steamUser.createdAt ?? ''),
            ),
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontSize: 14, color: AppColors.grey),
          ),
          const SizedBox(height: 12),

          // Stats Row
          Text(
            _buildStatsText(),
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontSize: 14, color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    final isScrolled =
        _scrollController.hasClients && _scrollController.offset > 0;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  void _showWebviewBottomSheet(String url, String title) {
    unawaited(
      NavigatorUtils.showPageModalBottomSheet<void>(
        context,
        UserDetailWebviewView(
          url: url,
          title: title,
          pageName: PageName.contactSellerProfile,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
