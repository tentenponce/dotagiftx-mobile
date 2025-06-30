import 'package:dio/dio.dart' hide Headers;
import 'package:dotagiftx_mobile/data/core/dio/dio_provider.dart';
import 'package:dotagiftx_mobile/data/responses/catalog_response.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'dotagiftx_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class DotagiftxApi {
  @factoryMethod
  factory DotagiftxApi(BasicDioProvider dioProvider, @baseUrl String baseUrl) =>
      _DotagiftxApi(dioProvider.create<DotagiftxApi>(), baseUrl: baseUrl);

  @GET('/catalogs?sort=recent-bid&limit=5')
  Future<CatalogResponse> getRecentBids();
}
