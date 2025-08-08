import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/responses/market_listing_response.dart';
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
  final KeychainStorage _keychainStorage;

  GetMyOrdersUsecaseImpl(this._dotagiftxApi, this._keychainStorage);

  @override
  Future<(List<MarketListingModel>, int)> get({
    required int page,
    required int limit,
    int? status,
    String? searchQuery,
  }) async {
    MarketListingResponse? response;
    if (status == ApiConstants.queryMarketStatusReserved) {
      final partnerSteamId = await _keychainStorage.getValue(
        KeychainKeys.steamId,
      );

      response = await _dotagiftxApi.getMarkets(
        null,
        page,
        limit,
        ApiConstants.queryMarketAsk,
        ApiConstants.queryMarketStatusReserved,
        null,
        ApiConstants.querySortUpdatedAtDesc,
        null,
        partnerSteamId,
      );
    } else {
      response = await _dotagiftxApi.getMyMarkets(
        page,
        limit,
        ApiConstants.queryMarketBid,
        status,
        ApiConstants.querySortUpdatedAtDesc,
        ApiConstants.queryIndexItemId,
        searchQuery,
      );
    }

    return (response.data, response.totalCount);
  }
}
