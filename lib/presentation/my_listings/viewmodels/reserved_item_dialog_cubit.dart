import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/domain/usecases/cancel_reserve_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/deliver_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/reserved_item_dialog_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReservedItemDialogCubit extends BaseCubit<ReservedItemDialogState>
    with CubitErrorMixin<ReservedItemDialogState> {
  late final void Function(String message) showCancelReservationError;
  late final void Function(String message) showDeliverItemError;
  late final void Function() dismissDialog;

  final Logger _logger;
  final CancelReserveMyListingUsecase _cancelReserveMyListingUsecase;
  final DeliverMyListingUsecase _deliverMyListingUsecase;

  ReservedItemDialogCubit(
    this._logger,
    this._cancelReserveMyListingUsecase,
    this._deliverMyListingUsecase,
  ) : super(const ReservedItemDialogState());

  @override
  Logger get logger => _logger;

  Future<void> cancelReservation({
    required String marketId,
    String? notes,
  }) async {
    emit(state.copyWith(isCancelReservationLoading: true));
    await cubitHandler(
      () => _cancelReserveMyListingUsecase.cancel(
        marketId: marketId,
        notes: notes,
      ),
      (response) async {
        dismissDialog();
      },
      onError: (e, st) async {
        if (e is BadRequestException &&
            !StringUtils.isNullOrEmpty(e.apiErrorMessage)) {
          showCancelReservationError(e.apiErrorMessage!);
        } else {
          showCancelReservationError(e.toString());
          _logger.log(LogLevel.error, 'Error canceling reservation', e, st);
        }
      },
    );

    emit(state.copyWith(isCancelReservationLoading: false));
  }

  Future<void> deliverItem({required String marketId, String? notes}) async {
    emit(state.copyWith(isDeliverItemLoading: true));
    await cubitHandler(
      () => _deliverMyListingUsecase.deliver(marketId: marketId, notes: notes),
      (response) async {
        dismissDialog();
      },
      onError: (e, st) async {
        if (e is BadRequestException &&
            !StringUtils.isNullOrEmpty(e.apiErrorMessage)) {
          showDeliverItemError(e.apiErrorMessage!);
        } else {
          showDeliverItemError(e.toString());
          _logger.log(LogLevel.error, 'Error delivering item', e, st);
        }
      },
    );

    emit(state.copyWith(isDeliverItemLoading: false));
  }

  @override
  Future<void> init() async {}
}
