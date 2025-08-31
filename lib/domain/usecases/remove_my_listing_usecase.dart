import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/patch_my_market_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class RemoveMyListingUsecase {
  Future<void> remove(String marketId);
}

@LazySingleton(as: RemoveMyListingUsecase)
class RemoveMyListingUsecaseImpl implements RemoveMyListingUsecase {
  final DotagiftxAuthApi _dotagiftxAuthApi;

  RemoveMyListingUsecaseImpl(this._dotagiftxAuthApi);

  @override
  Future<void> remove(String marketId) async {
    await _dotagiftxAuthApi.patchMyMarket(
      marketId,
      const PatchMyMarketRequest(
        status: ApiConstants.queryMarketStatusOrderRemoved,
      ),
    );
  }
}
