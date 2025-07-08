import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetDotaItemOrdersUsecase {
  Future<(List<MarketListingModel>, int)> get({
    required String itemId,
    int limit,
    int page,
    String sort,
  });
}

@LazySingleton(as: GetDotaItemOrdersUsecase)
class GetDotaItemOrdersUsecaseImpl implements GetDotaItemOrdersUsecase {
  final DotagiftxApi _dotagiftxApi;

  GetDotaItemOrdersUsecaseImpl(this._dotagiftxApi);

  @override
  Future<(List<MarketListingModel>, int)> get({
    required String itemId,
    int limit = 10,
    int page = 1,
    String sort = ApiConstants.querySortHighest,
  }) async {
    final response = await _dotagiftxApi.getMarkets(
      itemId,
      page,
      limit,
      ApiConstants.queryMarketBid,
      ApiConstants.queryMarketStatusLive,
      null,
      sort,
      ApiConstants.queryIndexItemId,
    );

    return (response.data, response.totalCount);
  }
}
