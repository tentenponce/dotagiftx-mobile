import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/patch_my_market_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class DeliverMyListingUsecase {
  Future<void> deliver({required String marketId, String? notes});
}

@LazySingleton(as: DeliverMyListingUsecase)
class DeliverMyListingUsecaseImpl implements DeliverMyListingUsecase {
  final DotagiftxAuthApi _dotagiftxAuthApi;

  DeliverMyListingUsecaseImpl(this._dotagiftxAuthApi);

  @override
  Future<void> deliver({required String marketId, String? notes}) async {
    await _dotagiftxAuthApi.patchMyMarket(
      marketId,
      PatchMyMarketRequest(
        status: ApiConstants.queryMarketStatusSold,
        notes: notes,
      ),
    );
  }
}
