import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_order_dialog_state.freezed.dart';

@freezed
abstract class MyOrderDialogState with _$MyOrderDialogState {
  const factory MyOrderDialogState({
    @Default(false) bool isRemoveOrderLoading,
    @Default(false) bool isCompleteOrderLoading,
  }) = _MyOrderDialogState;
}
