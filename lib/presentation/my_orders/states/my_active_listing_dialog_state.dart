import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/models/market_summary_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_active_listing_dialog_state.freezed.dart';

@freezed
abstract class MyActiveListingDialogState with _$MyActiveListingDialogState {
  const factory MyActiveListingDialogState({
    @Default(false) bool isRemoveListingLoading,
    @Default(false) bool isReserveListingLoading,
  }) = _MyActiveListingDialogState;
}
