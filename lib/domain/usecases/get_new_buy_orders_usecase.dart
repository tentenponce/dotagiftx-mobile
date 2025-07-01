import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetNewBuyOrdersUsecase {
  Future<Iterable<DotaItemModel>> get({int limit, int page});
}

@LazySingleton(as: GetNewBuyOrdersUsecase)
class GetNewBuyOrdersUsecaseImpl implements GetNewBuyOrdersUsecase {
  final DotagiftxApi _dotagiftxApi;

  GetNewBuyOrdersUsecaseImpl(this._dotagiftxApi);

  @override
  Future<Iterable<DotaItemModel>> get({int limit = 5, int page = 1}) async {
    final response = await _dotagiftxApi.getCatalogs(
      ApiConstants.querySortRecentBid,
      limit,
      page,
    );

    return response.data;
  }
}
