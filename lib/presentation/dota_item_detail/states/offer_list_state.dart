import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer_list_state.freezed.dart';

@freezed
abstract class OffersListState with _$OffersListState {
  const factory OffersListState({
    @Default([]) List<MarketListingModel> offers,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(0) int totalOffersCount,
    @Default(0) int currentPage,
    @Default(ApiConstants.querySortLowest) String sort,
  }) = _OffersListState;
}
