import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetMyListingsUsecase {
  Future<(List<MarketListingModel>, int)> get({
    required int limit,
    required int page,
    int? status,
  });
}

@LazySingleton(as: GetMyListingsUsecase)
class GetMyListingsUsecaseImpl implements GetMyListingsUsecase {
  final DotagiftxAuthApi _dotagiftxApi;

  GetMyListingsUsecaseImpl(this._dotagiftxApi);

  @override
  Future<(List<MarketListingModel>, int)> get({
    required int page,
    required int limit,
    int? status = ApiConstants.queryMarketStatusReserved,
  }) async {
    final response = await _dotagiftxApi.getMyMarkets(
      page,
      limit,
      ApiConstants.queryMarketAsk,
      status,
      ApiConstants.querySortUpdatedAtDesc,
      ApiConstants.queryIndexItemId,
    );

    return (response.data, response.totalCount);
  }
}
