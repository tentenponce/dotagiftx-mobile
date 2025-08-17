import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/domain/models/market_summary_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetMarketSummaryUsecase {
  Future<MarketSummaryModel> get();
}

@LazySingleton(as: GetMarketSummaryUsecase)
class GetMarketSummaryUsecaseImpl implements GetMarketSummaryUsecase {
  final DotagiftxUnauthApi _dotagiftxUnauthApi;
  final KeychainStorage _keychainStorage;

  GetMarketSummaryUsecaseImpl(this._dotagiftxUnauthApi, this._keychainStorage);

  @override
  Future<MarketSummaryModel> get() async {
    final steamId = await _keychainStorage.getValue(KeychainKeys.steamId);
    final userId = await _keychainStorage.getValue(KeychainKeys.userId);

    final futurePartnerSummary = _dotagiftxUnauthApi.getPartnerMarketSummary(
      steamId ?? '',
    );
    final futureUserSummary = _dotagiftxUnauthApi.getUserMarketSummary(
      userId ?? '',
      ApiConstants.queryIndexUserId,
    );
    final futureOrdersUserSummary = _dotagiftxUnauthApi.getUserMarketSummary(
      userId ?? '',
      null,
    );

    final partnerSummary = await futurePartnerSummary;
    final userSummary = await futureUserSummary;
    final ordersUserSummary = await futureOrdersUserSummary;

    return MarketSummaryModel(
      activeListings: userSummary.live,
      reservedListings: userSummary.reserved,
      deliveredListings: userSummary.sold,
      toReceiveOrders: partnerSummary.reserved,
      completedOrders: ordersUserSummary.bidCompleted,
    );
  }
}
