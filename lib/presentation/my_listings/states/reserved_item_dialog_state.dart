import 'package:freezed_annotation/freezed_annotation.dart';

part 'reserved_item_dialog_state.freezed.dart';

@freezed
abstract class ReservedItemDialogState with _$ReservedItemDialogState {
  const factory ReservedItemDialogState({
    @Default(false) bool isCancelReservationLoading,
    @Default(false) bool isDeliverItemLoading,
  }) = _ReservedItemDialogState;
}
