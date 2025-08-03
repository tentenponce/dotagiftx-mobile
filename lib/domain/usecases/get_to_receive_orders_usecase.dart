import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetToReceiveOrdersUsecase {
  Future<(List<MarketListingModel>, int)> get({
    required int limit,
    required int page,
  });
}

@LazySingleton(as: GetToReceiveOrdersUsecase)
class GetToReceiveOrdersUsecaseImpl implements GetToReceiveOrdersUsecase {
  final DotagiftxAuthApi _dotagiftxApi;
  final KeychainStorage _keychainStorage;

  GetToReceiveOrdersUsecaseImpl(this._dotagiftxApi, this._keychainStorage);

  @override
  Future<(List<MarketListingModel>, int)> get({
    required int limit,
    required int page,
  }) async {
    final partnerSteamId = await _keychainStorage.getValue(
      KeychainKeys.steamId,
    );

    final response = await _dotagiftxApi.getMarkets(
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

    return (response.data, response.totalCount);
  }
}
