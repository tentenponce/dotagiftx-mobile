import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dota_item_detail_state.freezed.dart';

@freezed
abstract class DotaItemDetailState with _$DotaItemDetailState {
  const factory DotaItemDetailState({
    @Default([]) List<MarketListingModel> offers,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(0) int totalOffersCount,
    @Default(0) int currentPage,
  }) = _DotaItemDetailState;
}
