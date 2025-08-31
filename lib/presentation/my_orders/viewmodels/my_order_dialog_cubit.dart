import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:dotagiftx_mobile/domain/usecases/complete_order_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/remove_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/states/my_order_dialog_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyOrderDialogCubit extends BaseCubit<MyOrderDialogState>
    with CubitErrorMixin<MyOrderDialogState> {
  late final void Function(String message) showRemoveOrderError;
  late final void Function() dismissDialog;
  late final void Function() showNullPartnerSteamIdError;
  late final void Function() showInvalidUrlError;
  late final void Function() showInvalidSteamIdUrlError;
  late final void Function(String message) showCompleteOrderErrorMessage;

  final Logger _logger;
  final RemoveMyListingUsecase _removeMyListingUsecase;
  final CompleteOrderUsecase _completeOrderUsecase;

  MyOrderDialogCubit(
    this._logger,
    this._removeMyListingUsecase,
    this._completeOrderUsecase,
  ) : super(const MyOrderDialogState());

  @override
  Logger get logger => _logger;

  Future<void> completeOrder(
    String marketId,
    String partnerSteamId,
    String? notes,
  ) async {
    emit(state.copyWith(isCompleteOrderLoading: true));

    await cubitHandler(
      () => _completeOrderUsecase.complete(
        marketId: marketId,
        partnerSteamId: partnerSteamId,
        notes: notes,
      ),
      (response) async {
        dismissDialog();
      },
      onError: (e, st) async {
        if (e is NullPartnerSteamIdException) {
          showNullPartnerSteamIdError();
        } else if (e is InvalidUrlException) {
          showInvalidUrlError();
        } else if (e is InvalidSteamIdUrlException) {
          showInvalidSteamIdUrlError();
        } else if (e is BadRequestException &&
            !StringUtils.isNullOrEmpty(e.apiErrorMessage)) {
          showCompleteOrderErrorMessage(e.apiErrorMessage!);
        } else {
          showCompleteOrderErrorMessage(e.toString());

          _logger.log(LogLevel.error, 'Error completing order', e, st);
        }
      },
    );

    emit(state.copyWith(isCompleteOrderLoading: false));
  }

  @override
  Future<void> init() async {}

  Future<void> removeOrder(String marketId) async {
    emit(state.copyWith(isRemoveOrderLoading: true));
    await cubitHandler(
      () => _removeMyListingUsecase.remove(marketId),
      (response) async {
        dismissDialog();
      },
      onError: (e, st) async {
        if (e is BadRequestException &&
            !StringUtils.isNullOrEmpty(e.apiErrorMessage)) {
          showRemoveOrderError(e.apiErrorMessage!);
        } else {
          showRemoveOrderError(e.toString());

          _logger.log(LogLevel.error, 'Error removing order', e, st);
        }
      },
    );

    emit(state.copyWith(isRemoveOrderLoading: false));
  }
}
