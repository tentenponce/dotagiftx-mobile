import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/date_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/number_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_outline_button.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_text_field.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/dotagiftx_image_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/reserved_item_dialog_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/reserved_item_dialog_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservedItemDialogView extends BasePageStatelessWidget
    with ViewCubitMixin<ReservedItemDialogCubit> {
  final MarketListingModel listing;
  const ReservedItemDialogView({required this.listing, super.key})
    : super(pageName: PageName.reservedItemDialog);

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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  style: AppTextStyles.defaultTextStyle(
                    context,
                  ).copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 28,
                  ),
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
                        style: AppTextStyles.defaultTextStyle(
                          context,
                        ).copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            I18n.of(context).myActiveListingDialogViewStatus,
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(fontSize: 16),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            I18n.of(context).toReceiveItemViewReserved,
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(
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
                        style: AppTextStyles.defaultTextStyle(
                          context,
                        ).copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        I18n.of(context).reservedItemViewReservedDate(
                          DateFormatUtils.formatExactDateTime(
                            widget.listing.updatedAt ?? '',
                          ),
                        ),
                        style: AppTextStyles.defaultTextStyle(
                          context,
                        ).copyWith(fontSize: 16),
                      ),
                      if (!StringUtils.isNullOrEmpty(widget.listing.notes)) ...[
                        const SizedBox(height: 8),
                        Text(
                          I18n.of(context).reservedItemDialogViewBuyerNotes,
                          style: AppTextStyles.defaultTextStyle(
                            context,
                          ).copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.listing.notes!,
                          style: AppTextStyles.defaultTextStyle(
                            context,
                          ).copyWith(
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
                      style: AppTextStyles.defaultTextStyle(
                        context,
                      ).copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: TextEditingController(
                        text: RemoteConfigConstants.defaultSteamProfileUrl(
                          widget.listing.partnerSteamId ?? '',
                        ),
                      ),
                      maxLines: 2,
                      enabled: false,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  I18n.of(context).reservedItemDialogViewActionNotes,
                  style: AppTextStyles.defaultTextStyle(
                    context,
                  ).copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _notesController,
                  maxLines: 3,
                  hintText:
                      I18n.of(context).reservedItemDialogViewActionNotesHint,
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
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.red, width: 1),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cancel,
                              size: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              I18n.of(
                                context,
                              ).reservedItemDialogViewCancelButton,
                              style: AppTextStyles.defaultTextStyle(
                                context,
                              ).copyWith(
                                fontSize: 14,
                                color: Colors.red,
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
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 1,
                          ),
                          elevation: 0,
                        ),
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
                            Icon(
                              Icons.assignment_turned_in,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              I18n.of(
                                context,
                              ).reservedItemDialogViewDeliverButton,
                              style: AppTextStyles.defaultTextStyle(
                                context,
                              ).copyWith(
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
              ],
            ),

            // Error messages
            if (!StringUtils.isNullOrEmpty(_cancelReservationError)) ...[
              const SizedBox(height: 16),
              Text(
                _cancelReservationError!,
                style: AppTextStyles.defaultTextStyle(
                  context,
                ).copyWith(color: Colors.red),
              ),
            ],
            if (!StringUtils.isNullOrEmpty(_deliverItemError)) ...[
              const SizedBox(height: 16),
              Text(
                _deliverItemError!,
                style: AppTextStyles.defaultTextStyle(
                  context,
                ).copyWith(color: Colors.red),
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
