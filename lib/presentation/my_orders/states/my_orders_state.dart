import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_orders_state.freezed.dart';

@freezed
abstract class MyOrdersState with _$MyOrdersState {
  const factory MyOrdersState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default([]) List<MarketListingModel> orders,
    @Default(0) int totalOrdersCount,
  }) = _MyOrdersState;
}
