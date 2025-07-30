import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetMyOrdersUsecase {
  Future<(List<MarketListingModel>, int)> get({
    required int limit,
    required int page,
    int? status,
    String? searchQuery,
  });
}

@LazySingleton(as: GetMyOrdersUsecase)
class GetMyOrdersUsecaseImpl implements GetMyOrdersUsecase {
  final DotagiftxAuthApi _dotagiftxApi;

  GetMyOrdersUsecaseImpl(this._dotagiftxApi);

  @override
  Future<(List<MarketListingModel>, int)> get({
    required int page,
    required int limit,
    int? status = ApiConstants.queryMarketStatusLive,
    String? searchQuery,
  }) async {
    final response = await _dotagiftxApi.getMyMarkets(
      page,
      limit,
      ApiConstants.queryMarketBid,
      status,
      ApiConstants.querySortUpdatedAtDesc,
      ApiConstants.queryIndexItemId,
      searchQuery,
    );

    return (response.data, response.totalCount);
  }
}
