import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/post_my_market_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class PlaceBuyOrderUsecase {
  Future<void> placeBuyOrder({
    required String itemId,
    required double price,
    String? notes,
  });
}

@LazySingleton(as: PlaceBuyOrderUsecase)
class PlaceBuyOrderUsecaseImpl implements PlaceBuyOrderUsecase {
  final DotagiftxAuthApi _dotagiftxAuthApi;

  PlaceBuyOrderUsecaseImpl(this._dotagiftxAuthApi);

  @override
  Future<void> placeBuyOrder({
    required String itemId,
    required double price,
    String? notes,
  }) async {
    notes = notes ?? '';

    await _dotagiftxAuthApi.postMyMarket(
      PostMyMarketRequest(
        itemId: itemId,
        price: price,
        notes: notes,
        type: ApiConstants.queryMarketBid,
      ),
    );
  }
}
