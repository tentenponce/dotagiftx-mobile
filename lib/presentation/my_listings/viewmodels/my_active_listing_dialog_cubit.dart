import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:dotagiftx_mobile/domain/usecases/remove_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/reserve_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/states/my_active_listing_dialog_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyActiveListingDialogCubit extends BaseCubit<MyActiveListingDialogState>
    with CubitErrorMixin<MyActiveListingDialogState> {
  late final void Function(String message) showToastError;
  late final void Function() dismissDialog;
  late final void Function() showNullPartnerSteamIdError;
  late final void Function() showInvalidUrlError;
  late final void Function() showInvalidSteamIdUrlError;
  late final void Function(String message) showReserveErrorMessage;

  final Logger _logger;
  final RemoveMyListingUsecase _removeMyListingUsecase;
  final ReserveMyListingUsecase _reserveMyListingUsecase;

  MyActiveListingDialogCubit(
    this._logger,
    this._removeMyListingUsecase,
    this._reserveMyListingUsecase,
  ) : super(const MyActiveListingDialogState());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {}

  Future<void> removeListing(String marketId) async {
    emit(state.copyWith(isRemoveListingLoading: true));
    await cubitHandler(
      () => _removeMyListingUsecase.remove(marketId),
      (response) async {
        dismissDialog();
      },
      onError: (e, st) async {
        if (e is BadRequestException &&
            !StringUtils.isNullOrEmpty(e.apiErrorMessage)) {
          showToastError(e.apiErrorMessage!);
        } else {
          showToastError(e.toString());

          _logger.log(LogLevel.error, 'Error removing listing', e, st);
        }
      },
    );

    emit(state.copyWith(isRemoveListingLoading: false));
  }

  Future<void> reserveListing(
    String marketId,
    String partnerSteamId,
    String? notes,
  ) async {
    emit(state.copyWith(isReserveListingLoading: true));

    await cubitHandler(
      () => _reserveMyListingUsecase.reserve(
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
          showReserveErrorMessage(e.apiErrorMessage!);
        } else {
          showReserveErrorMessage(e.toString());

          _logger.log(LogLevel.error, 'Error reserving listing', e, st);
        }
      },
    );

    emit(state.copyWith(isReserveListingLoading: false));
  }
}
