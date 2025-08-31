import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/core/utils/url_utils.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/data/requests/patch_my_market_request.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:injectable/injectable.dart';

abstract interface class CompleteOrderUsecase {
  Future<void> complete({
    required String marketId,
    required String partnerSteamId,
    String? notes,
  });
}

@LazySingleton(as: CompleteOrderUsecase)
class CompleteOrderUsecaseImpl implements CompleteOrderUsecase {
  final DotagiftxAuthApi _dotagiftxAuthApi;

  CompleteOrderUsecaseImpl(this._dotagiftxAuthApi);

  @override
  Future<void> complete({
    required String marketId,
    required String partnerSteamId,
    String? notes,
  }) async {
    if (StringUtils.isNullOrEmpty(partnerSteamId)) {
      throw NullPartnerSteamIdException();
    }

    if (!UrlUtils.isValid(partnerSteamId)) {
      throw InvalidUrlException();
    }

    if (!partnerSteamId.startsWith(
      RemoteConfigConstants.steamPartnerIdBaseUrl,
    )) {
      throw InvalidSteamIdUrlException();
    }

    await _dotagiftxAuthApi.patchMyMarket(
      marketId,
      PatchMyMarketRequest(
        status: ApiConstants.queryMarketStatusCompleted,
        partnerSteamId: partnerSteamId,
        notes: notes,
      ),
    );
  }
}
