import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/patch_my_market_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class ReserveMyListingUsecase {
  Future<void> reserve({
    required String marketId,
    required String partnerSteamId,
    String? notes,
  });
}

@LazySingleton(as: ReserveMyListingUsecase)
class ReserveMyListingUsecaseImpl implements ReserveMyListingUsecase {
  final DotagiftxAuthApi _dotagiftxAuthApi;

  ReserveMyListingUsecaseImpl(this._dotagiftxAuthApi);

  @override
  Future<void> reserve({
    required String marketId,
    required String partnerSteamId,
    String? notes,
  }) async {
    await _dotagiftxAuthApi.patchMyMarket(
      marketId,
      PatchMyMarketRequest(
        status: ApiConstants.queryMarketStatusReserved,
        partnerSteamId: partnerSteamId,
        notes: notes,
      ),
    );
  }
}
