import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetTrendingUsecase {
  Future<Iterable<DotaItemModel>> get();
}

@LazySingleton(as: GetTrendingUsecase)
class GetTrendingUsecaseImpl implements GetTrendingUsecase {
  final DotagiftxApi _dotagiftxApi;

  GetTrendingUsecaseImpl(this._dotagiftxApi);

  @override
  Future<Iterable<DotaItemModel>> get() async {
    final response = await _dotagiftxApi.getTrendingCatalogs();

    return response.data;
  }
}
