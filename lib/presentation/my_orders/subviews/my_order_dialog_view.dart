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
import 'package:dotagiftx_mobile/presentation/my_orders/states/my_order_dialog_state.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/viewmodels/my_order_dialog_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrderDialogView extends BasePageStatelessWidget
    with ViewCubitMixin<MyOrderDialogCubit> {
  final MarketListingModel listing;
  const MyOrderDialogView({required this.listing, super.key})
    : super(pageName: PageName.myOrderDetailDialog);

  @override
  Widget buildView(BuildContext context) {
    return _MyOrderDialogView(listing: listing);
  }
}

class _MyOrderDialogView extends StatefulWidget {
  final MarketListingModel listing;

  const _MyOrderDialogView({required this.listing});

  @override
  State<_MyOrderDialogView> createState() => _MyOrderDialogViewState();
}

class _MyOrderDialogViewState extends State<_MyOrderDialogView> {
  final TextEditingController _steamUrlController = TextEditingController();
  final TextEditingController _reservationNotesController =
      TextEditingController();

  String? _removeOrderError;
  String? _steamProfileUrlError;

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
                  I18n.of(context).myOrderDialogViewTitle,
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
                            I18n.of(context).myOrderDialogViewStatus,
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(fontSize: 16),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            I18n.of(context).myOrderDialogViewListed,
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(
                              color: Colors.green[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        I18n.of(context).myOrderDialogViewPrice(
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
                        I18n.of(context).myOrderDialogViewOrderedDate(
                          DateFormatUtils.formatExactDateTime(
                            widget.listing.createdAt ?? '',
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

            // Steam profile URL input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  I18n.of(context).myOrderDialogViewBuyerSteamProfileUrl,
                  style: AppTextStyles.defaultTextStyle(
                    context,
                  ).copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _steamUrlController,
                  error:
                      !StringUtils.isNullOrEmpty(_steamProfileUrlError)
                          ? Text(
                            _steamProfileUrlError!,
                            style: const TextStyle(color: Colors.red),
                          )
                          : null,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Reservation notes input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  I18n.of(context).myOrderDialogViewReservationNotes,
                  style: AppTextStyles.defaultTextStyle(
                    context,
                  ).copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _reservationNotesController,
                  maxLines: 4,
                  hintText:
                      I18n.of(
                        context,
                      ).myOrderDialogViewReservationNotesDescription,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<MyOrderDialogCubit, MyOrderDialogState>(
                    buildWhen:
                        (previous, current) =>
                            previous.isRemoveOrderLoading !=
                            current.isRemoveOrderLoading,
                    builder: (context, state) {
                      return AppOutlineButton(
                        isLoading: state.isRemoveOrderLoading,
                        onPressed:
                            () => unawaited(
                              context.read<MyOrderDialogCubit>().removeOrder(
                                widget.listing.id,
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
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              I18n.of(context).myOrderDialogViewRemoveButton,
                              style: AppTextStyles.defaultTextStyle(
                                context,
                              ).copyWith(
                                color: Colors.red,
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
                  child: BlocBuilder<MyOrderDialogCubit, MyOrderDialogState>(
                    buildWhen:
                        (previous, current) =>
                            previous.isCompleteOrderLoading !=
                            current.isCompleteOrderLoading,
                    builder: (context, state) {
                      return AppOutlineButton(
                        isLoading: state.isCompleteOrderLoading,
                        onPressed:
                            () => unawaited(
                              context.read<MyOrderDialogCubit>().completeOrder(
                                widget.listing.id,
                                _steamUrlController.text,
                                _reservationNotesController.text,
                              ),
                            ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_available,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              I18n.of(context).myOrderDialogViewCompleteButton,
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
            if (!StringUtils.isNullOrEmpty(_removeOrderError)) ...[
              const SizedBox(height: 16),
              Text(
                _removeOrderError!,
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
    _steamUrlController.dispose();
    _reservationNotesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<MyOrderDialogCubit>()
      ..showRemoveOrderError = (message) {
        setState(() {
          _removeOrderError = message;
        });
      }
      ..dismissDialog = () {
        Navigator.of(context).pop(true);
      }
      ..showNullPartnerSteamIdError = () {
        setState(() {
          _steamProfileUrlError =
              I18n.of(context).myOrdersNullPartnerSteamIdError;
        });
      }
      ..showInvalidUrlError = () {
        setState(() {
          _steamProfileUrlError = I18n.of(context).myOrdersInvalidUrlError;
        });
      }
      ..showInvalidSteamIdUrlError = () {
        setState(() {
          _steamProfileUrlError = I18n.of(
            context,
          ).myOrdersInvalidSteamIdUrlError(
            RemoteConfigConstants.steamPartnerIdBaseUrl,
          );
        });
      }
      ..showCompleteOrderErrorMessage = (message) {
        setState(() {
          _steamProfileUrlError = message;
        });
      };
  }
}
