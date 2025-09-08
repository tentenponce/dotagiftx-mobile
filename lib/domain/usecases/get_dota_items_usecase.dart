import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetDotaItemsUsecase {
  Future<Iterable<DotaItemModel>> get();
}

@LazySingleton(as: GetDotaItemsUsecase)
class GetDotaItemsUsecaseImpl implements GetDotaItemsUsecase {
  final DotagiftxUnauthApi _dotagiftxUnauthApi;

  GetDotaItemsUsecaseImpl(this._dotagiftxUnauthApi);

  @override
  Future<Iterable<DotaItemModel>> get() async {
    final response = await _dotagiftxUnauthApi.getDotaItems(
      1000,
      true.toString(),
      ApiConstants.querySortCreatedAtDesc,
    );

    // we don't care about the total count for now, items are around 300+ only, and we're fetching for 1000 items
    return response.data;
  }
}
