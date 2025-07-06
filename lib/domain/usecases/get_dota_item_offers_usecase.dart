import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetDotaItemOffersUsecase {
  Future<(List<MarketListingModel>, int)> get({
    required String itemId,
    int limit,
    int page,
  });
}

@LazySingleton(as: GetDotaItemOffersUsecase)
class GetDotaItemOffersUsecaseImpl implements GetDotaItemOffersUsecase {
  final DotagiftxApi _dotagiftxApi;

  GetDotaItemOffersUsecaseImpl(this._dotagiftxApi);

  @override
  Future<(List<MarketListingModel>, int)> get({
    required String itemId,
    int limit = 10,
    int page = 1,
  }) async {
    final response = await _dotagiftxApi.getMarkets(
      itemId,
      page,
      limit,
      ApiConstants.queryMarketAsk,
      ApiConstants.queryMarketStatusLive,
      ApiConstants.queryInventoryStatusVerified,
      ApiConstants.querySortLowest,
      ApiConstants.queryIndexItemId,
    );

    return (response.data, response.totalCount);
  }
}
