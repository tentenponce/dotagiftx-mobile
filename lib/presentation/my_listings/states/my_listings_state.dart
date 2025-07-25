import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_listings_state.freezed.dart';

@freezed
abstract class MyListingsState with _$MyListingsState {
  const factory MyListingsState({
    @Default(false) bool loadingListings,
    @Default(false) bool loadingMoreListings,
    @Default([]) List<MarketListingModel> listings,
    @Default(0) int totalListingsCount,
    @Default(1) int currentPage,
    @Default(ApiConstants.queryMarketStatusLive) int status,
  }) = _MyListingsState;
}
