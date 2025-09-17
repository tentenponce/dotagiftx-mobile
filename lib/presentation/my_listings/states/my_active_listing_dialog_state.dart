import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_active_listing_dialog_state.freezed.dart';

@freezed
abstract class MyActiveListingDialogState with _$MyActiveListingDialogState {
  const factory MyActiveListingDialogState({
    @Default(false) bool isRemoveListingLoading,
    @Default(false) bool isReserveListingLoading,
  }) = _MyActiveListingDialogState;
}
