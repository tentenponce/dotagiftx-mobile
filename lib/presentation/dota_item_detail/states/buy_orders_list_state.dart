import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'buy_orders_list_state.freezed.dart';

@freezed
abstract class BuyOrdersListState with _$BuyOrdersListState {
  const factory BuyOrdersListState({
    @Default([]) List<MarketListingModel> buyOrders,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(0) int totalBuyOrdersCount,
    @Default(ApiConstants.querySortHighest) String sort,
  }) = _BuyOrdersListState;
}
