import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class SearchCatalogUsecase {
  Future<Iterable<DotaItemModel>> search({
    required String query,
    int limit,
    int page,
  });
}

@LazySingleton(as: SearchCatalogUsecase)
class SearchCatalogUsecaseImpl implements SearchCatalogUsecase {
  final DotagiftxApi _dotagiftxApi;

  SearchCatalogUsecaseImpl(this._dotagiftxApi);

  @override
  Future<Iterable<DotaItemModel>> search({
    required String query,
    int limit = 10,
    int page = 1,
  }) async {
    final response = await _dotagiftxApi.getCatalogs(
      ApiConstants.querySortPopular,
      limit,
      page,
      query,
    );

    return response.data;
  }
}
