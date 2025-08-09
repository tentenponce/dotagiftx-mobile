import 'package:dotagiftx_mobile/data/core/constants/verified_inventory_constants.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class ItemVerificationIconView extends StatefulWidget {
  final int? status;
  final bool? isResell;
  final String? name;
  final String? createdAt;

  const ItemVerificationIconView({
    required this.status,
    this.isResell = false,
    this.name,
    this.createdAt,
    super.key,
  });

  @override
  State<ItemVerificationIconView> createState() =>
      _ItemVerificationIconViewState();
}

class _ItemVerificationIconViewState extends State<ItemVerificationIconView> {
  OverlayEntry? _overlayEntry;

  final _iconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    Color? color;
    if (widget.status == VerifiedInventoryConstants.pending) {
      icon = Icons.pending;
      color = AppColors.grey;
    } else if (widget.status == VerifiedInventoryConstants.noHit) {
      icon = Icons.block;
      color = AppColors.grey;
    } else if (widget.status == VerifiedInventoryConstants.private) {
      icon = Icons.visibility_off;
      color = AppColors.grey;
    } else if (widget.status == VerifiedInventoryConstants.error) {
      icon = Icons.error_outline;
      color = AppColors.grey;
    } else if ((widget.isResell ?? false) &&
        widget.status == VerifiedInventoryConstants.verified) {
      icon = Icons.check_circle_outline;
      color = const Color(0xFF2BDAC9);
    } else if (widget.status == VerifiedInventoryConstants.verified) {
      icon = Icons.check;
      color = Colors.green;
    }

    if (icon != null) {
      return GestureDetector(
        key: _iconKey,
        onTapDown:
            (_) => _showTooltip(context, _iconKey), // Show immediately on press
        onTapUp: (_) => _removeTooltip(), // Remove when finger lifts
        onTapCancel: _removeTooltip, // Also remove if gesture is canceled
        child: Icon(icon, color: color, size: 24),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showTooltip(BuildContext context, GlobalKey key) {
    final renderBox = key.currentContext!.findRenderObject()! as RenderBox;
    final target = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    var title = '';
    var description = '';

    if (widget.status == VerifiedInventoryConstants.pending) {
      title = I18n.of(context).itemVerificationIconPendingTitleTooltip;
      description = I18n.of(
        context,
      ).itemVerificationIconPendingDescriptionTooltip(
        DateFormatUtils.formatDateAgo(widget.createdAt ?? ''),
      );
    } else if (widget.status == VerifiedInventoryConstants.noHit) {
      title = I18n.of(context).itemVerificationIconNoHitTitleTooltip;
      description =
          I18n.of(context).itemVerificationIconNoHitDescriptionTooltip;
    } else if (widget.status == VerifiedInventoryConstants.private) {
      title = I18n.of(context).itemVerificationIconPrivateTitleTooltip;
      description =
          I18n.of(context).itemVerificationIconPrivateDescriptionTooltip;
    } else if (widget.status == VerifiedInventoryConstants.error) {
      title = I18n.of(context).itemVerificationIconErrorTitleTooltip;
      description =
          I18n.of(context).itemVerificationIconErrorDescriptionTooltip;
    } else if ((widget.isResell ?? false) &&
        widget.status == VerifiedInventoryConstants.verified) {
      title = I18n.of(context).itemVerificationIconResellTitleTooltip;
      description = I18n.of(
        context,
      ).itemVerificationIconResellDescriptionTooltip(
        widget.name ?? '',
        DateFormatUtils.formatDateAgo(widget.createdAt ?? ''),
      );
    } else if (widget.status == VerifiedInventoryConstants.verified) {
      title = I18n.of(context).itemVerificationIconVerifiedTitleTooltip;
      description =
          I18n.of(context).itemVerificationIconVerifiedDescriptionTooltip;
    }

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: target.dy + (size.height / 2) - 100,
            left: target.dx + (size.width / 2) - 100,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.dirtyWhite,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}
