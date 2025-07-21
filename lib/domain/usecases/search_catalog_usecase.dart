import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class SearchCatalogUsecase {
  Future<(Iterable<DotaItemModel>, int)> search({
    required String query,
    int limit,
    int page,
  });
}

@LazySingleton(as: SearchCatalogUsecase)
class SearchCatalogUsecaseImpl implements SearchCatalogUsecase {
  final DotagiftxUnauthApi _dotagiftxUnauthApi;

  SearchCatalogUsecaseImpl(this._dotagiftxUnauthApi);

  @override
  Future<(Iterable<DotaItemModel>, int)> search({
    required String query,
    int limit = 10,
    int page = 1,
  }) async {
    final response = await _dotagiftxUnauthApi.getCatalogs(
      ApiConstants.querySortPopular,
      limit,
      page,
      query,
    );

    return (response.data, response.totalCount);
  }
}
