import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_buy_order_state.freezed.dart';

@freezed
abstract class PlaceBuyOrderState with _$PlaceBuyOrderState {
  const factory PlaceBuyOrderState({
    @Default(false) bool isPlaceBuyOrderLoading,
    @Default(false) bool isPriceErrorRequired,
  }) = _PlaceBuyOrderState;
}
