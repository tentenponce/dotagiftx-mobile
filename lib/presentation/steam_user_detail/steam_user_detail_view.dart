import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/steam_user_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/user_subscription_badge_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:dotagiftx_mobile/presentation/steam_user_detail/guidelines_view.dart';
import 'package:dotagiftx_mobile/presentation/steam_user_detail/user_detail_webview.dart';
import 'package:flutter/material.dart';

class SteamUserDetailView extends StatefulWidget {
  final SteamUserModel steamUser;

  const SteamUserDetailView({required this.steamUser, super.key});

  @override
  State<SteamUserDetailView> createState() => _SteamUserDetailViewState();
}

class _SteamUserDetailViewState extends State<SteamUserDetailView> {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBody: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.black,
        elevation: 0,
        title: Text(
          I18n.of(context).steamUserDetailTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            onPressed:
                () => _showWebviewBottomSheet(
                  widget.steamUser.url ?? '',
                  I18n.of(context).steamUserDetailSteamProfileButton,
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              I18n.of(context).steamUserDetailSteamProfileButton,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                  GuidelinesView(
                    steamUser: widget.steamUser,
                    onShowWebview: _showWebviewBottomSheet,
                  ),
                ],
              ),
            ),
            // Top shadow when scrolled
            if (_isScrolled)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.black.withValues(alpha: 0.8),
                        AppColors.black.withValues(alpha: 0.4),
                        AppColors.black.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGrey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildActionButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          I18n.of(context).steamUserDetailSteamInventoryButton,
          () => _showWebviewBottomSheet(
            'https://steamcommunity.com/profiles/${widget.steamUser.steamId}/inventory/',
            I18n.of(context).steamUserDetailSteamInventoryButton,
          ),
        ),
        _buildActionButton(
          I18n.of(context).steamUserDetailSteamRepButton,
          () => _showWebviewBottomSheet(
            'https://steamrep.com/search?q=${widget.steamUser.steamId}',
            I18n.of(context).steamUserDetailSteamRepButton,
          ),
        ),
        _buildActionButton(
          I18n.of(context).steamUserDetailDotabuffButton,
          () => _showWebviewBottomSheet(
            'https://www.dotabuff.com/players/${widget.steamUser.steamId}',
            I18n.of(context).steamUserDetailDotabuffButton,
          ),
        ),
      ],
    );
  }

  String _buildStatsText() {
    final stats = widget.steamUser.marketStats;
    if (stats == null) {
      return I18n.of(context).steamUserDetailStats(0, 0, 0, 0);
    }

    return I18n.of(context).steamUserDetailStats(
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
            widget.steamUser.name ?? 'Unknown User',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
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
            I18n.of(context).steamUserDetailJoinedDate(
              DateFormatUtils.formatDateAgo(widget.steamUser.createdAt ?? ''),
            ),
            style: const TextStyle(color: AppColors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),

          // Stats Row
          Text(
            _buildStatsText(),
            style: const TextStyle(color: AppColors.grey, fontSize: 14),
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
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => WebViewBottomSheet(url: url, title: title),
      ),
    );
  }
}
