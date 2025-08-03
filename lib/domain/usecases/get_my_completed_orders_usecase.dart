import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetMyCompletedOrdersUsecase {
  Future<(List<MarketListingModel>, int)> get({
    required int limit,
    required int page,
    String? searchQuery,
  });
}

@LazySingleton(as: GetMyCompletedOrdersUsecase)
class GetMyCompletedOrdersUsecaseImpl implements GetMyCompletedOrdersUsecase {
  final DotagiftxAuthApi _dotagiftxApi;

  GetMyCompletedOrdersUsecaseImpl(this._dotagiftxApi);

  @override
  Future<(List<MarketListingModel>, int)> get({
    required int limit,
    required int page,
    String? searchQuery,
  }) async {
    final response = await _dotagiftxApi.getMyMarkets(
      page,
      limit,
      ApiConstants.queryMarketBid,
      ApiConstants.queryMarketStatusCompleted,
      ApiConstants.querySortUpdatedAtDesc,
      null,
      searchQuery,
    );

    return (response.data, response.totalCount);
  }
}
