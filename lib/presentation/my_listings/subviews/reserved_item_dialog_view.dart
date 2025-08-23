import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/number_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_outline_button.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/reserved_item_dialog_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/reserved_item_dialog_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservedItemDialogView extends StatelessWidget
    with ViewCubitMixin<ReservedItemDialogCubit> {
  final MarketListingModel listing;
  const ReservedItemDialogView({required this.listing, super.key});

  @override
  Widget buildView(BuildContext context) {
    return _ReservedItemDialogView(listing: listing);
  }
}

class _ReservedItemDialogView extends StatefulWidget {
  final MarketListingModel listing;

  const _ReservedItemDialogView({required this.listing});

  @override
  State<_ReservedItemDialogView> createState() =>
      _ReservedItemDialogViewState();
}

class _ReservedItemDialogViewState extends State<_ReservedItemDialogView> {
  final TextEditingController _notesController = TextEditingController();

  String? _cancelReservationError;
  String? _deliverItemError;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  I18n.of(context).reservedItemDialogViewTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Item details section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item image
                DotagiftxImageView(
                  imageUrl: widget.listing.item?.image ?? '',
                  rarity: widget.listing.item?.rarity ?? '',
                  width: 120,
                  height: 90,
                ),
                const SizedBox(width: 16),

                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.listing.item?.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            I18n.of(context).myActiveListingDialogViewStatus,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            I18n.of(context).toReceiveItemViewReserved,
                            style: const TextStyle(
                              color: AppColors.purple,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        I18n.of(context).myActiveListingDialogViewPrice(
                          NumberFormatUtils.formatDecimal(
                            widget.listing.price,
                            2,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        I18n.of(context).reservedItemViewReservedDate(
                          DateFormatUtils.formatExactDateTime(
                            widget.listing.updatedAt ?? '',
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      if (!StringUtils.isNullOrEmpty(widget.listing.notes)) ...[
                        const SizedBox(height: 8),
                        Text(
                          I18n.of(context).reservedItemDialogViewBuyerNotes,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.listing.notes!,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Notes input for actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Steam profile URL input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      I18n.of(
                        context,
                      ).reservedItemDialogViewBuyerSteamProfileUrl,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: TextEditingController(
                        text: RemoteConfigConstants.defaultSteamProfileUrl(
                          widget.listing.partnerSteamId ?? '',
                        ),
                      ),
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: AppColors.grey),
                        filled: true,
                        fillColor: AppColors.darkGrey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      enabled: false,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  I18n.of(context).reservedItemDialogViewActionNotes,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: AppColors.grey),
                    hintText:
                        I18n.of(context).reservedItemDialogViewActionNotesHint,
                    filled: true,
                    fillColor: AppColors.darkGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<
                    ReservedItemDialogCubit,
                    ReservedItemDialogState
                  >(
                    buildWhen:
                        (previous, current) =>
                            previous.isCancelReservationLoading !=
                            current.isCancelReservationLoading,
                    builder: (context, state) {
                      return AppOutlineButton(
                        isLoading: state.isCancelReservationLoading,
                        onPressed:
                            () => unawaited(
                              context
                                  .read<ReservedItemDialogCubit>()
                                  .cancelReservation(
                                    marketId: widget.listing.id,
                                    notes:
                                        _notesController.text.trim().isEmpty
                                            ? null
                                            : _notesController.text.trim(),
                                  ),
                            ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.white, width: 1),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cancel,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              I18n.of(
                                context,
                              ).reservedItemDialogViewCancelButton,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BlocBuilder<
                    ReservedItemDialogCubit,
                    ReservedItemDialogState
                  >(
                    buildWhen:
                        (previous, current) =>
                            previous.isDeliverItemLoading !=
                            current.isDeliverItemLoading,
                    builder: (context, state) {
                      return AppOutlineButton(
                        isLoading: state.isDeliverItemLoading,
                        onPressed:
                            () => unawaited(
                              context
                                  .read<ReservedItemDialogCubit>()
                                  .deliverItem(
                                    marketId: widget.listing.id,
                                    notes:
                                        _notesController.text.trim().isEmpty
                                            ? null
                                            : _notesController.text.trim(),
                                  ),
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.assignment_turned_in,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              I18n.of(
                                context,
                              ).reservedItemDialogViewDeliverButton,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Error messages
            if (!StringUtils.isNullOrEmpty(_cancelReservationError)) ...[
              const SizedBox(height: 16),
              Text(
                _cancelReservationError!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            if (!StringUtils.isNullOrEmpty(_deliverItemError)) ...[
              const SizedBox(height: 16),
              Text(
                _deliverItemError!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<ReservedItemDialogCubit>()
      ..showCancelReservationError = (message) {
        setState(() {
          _cancelReservationError = message;
          _deliverItemError = null; // Clear other error
        });
      }
      ..showDeliverItemError = (message) {
        setState(() {
          _deliverItemError = message;
          _cancelReservationError = null; // Clear other error
        });
      }
      ..dismissDialog = () {
        Navigator.of(context).pop(true);
      };
  }
}
