import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetTrendingUsecase {
  Future<Iterable<DotaItemModel>> get();
}

@LazySingleton(as: GetTrendingUsecase)
class GetTrendingUsecaseImpl implements GetTrendingUsecase {
  final DotagiftxUnauthApi _dotagiftxUnauthApi;

  GetTrendingUsecaseImpl(this._dotagiftxUnauthApi);

  @override
  Future<Iterable<DotaItemModel>> get() async {
    final response = await _dotagiftxUnauthApi.getTrendingCatalogs();

    return response.data;
  }
}
