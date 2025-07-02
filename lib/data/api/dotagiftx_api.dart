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

  @GET('/catalogs')
  Future<CatalogResponse> getCatalogs(
    @Query('sort') String sort,
    @Query('limit') int limit,
    @Query('page') int page,
    @Query('q') String? search,
  );

  @GET('/catalogs_trend')
  Future<CatalogResponse> getTrendingCatalogs();
}
