import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/patch_my_market_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class CancelReserveMyListingUsecase {
  Future<void> cancel({required String marketId, String? notes});
}

@LazySingleton(as: CancelReserveMyListingUsecase)
class CancelReserveMyListingUsecaseImpl
    implements CancelReserveMyListingUsecase {
  final DotagiftxAuthApi _dotagiftxAuthApi;

  CancelReserveMyListingUsecaseImpl(this._dotagiftxAuthApi);

  @override
  Future<void> cancel({required String marketId, String? notes}) async {
    await _dotagiftxAuthApi.patchMyMarket(
      marketId,
      PatchMyMarketRequest(
        status: ApiConstants.queryMarketStatusCancelled,
        notes: notes,
      ),
    );
  }
}
