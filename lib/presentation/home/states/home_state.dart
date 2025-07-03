import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool loadingTrendingItems,
    @Default(false) bool loadingNewBuyOrderItems,
    @Default(false) bool loadingNewSellListingItems,
    @Default(false) bool loadingSearchResults,
    @Default([]) Iterable<DotaItemModel> trendingItems,
    @Default([]) Iterable<DotaItemModel> newBuyOrderItems,
    @Default([]) Iterable<DotaItemModel> newSellListingItems,
    @Default([]) Iterable<DotaItemModel> searchResults,
  }) = _HomeState;
}
