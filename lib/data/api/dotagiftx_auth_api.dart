import 'package:dio/dio.dart' hide Headers;
import 'package:dotagiftx_mobile/data/core/dio/dio_provider.dart';
import 'package:dotagiftx_mobile/data/responses/market_listing_response.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'dotagiftx_auth_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class DotagiftxAuthApi {
  @factoryMethod
  factory DotagiftxAuthApi(
    AuthDioProviderImpl dioProvider,
    @baseUrl String baseUrl,
  ) => _DotagiftxAuthApi(
    dioProvider.create<DotagiftxAuthApi>(),
    baseUrl: baseUrl,
  );

  @GET('/markets')
  Future<MarketListingResponse> getMarkets(
    @Query('item_id') String itemId,
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('type') int type,
    @Query('status') int status,
    @Query('inventory_status') int? inventoryStatus,
    @Query('sort') String sort,
    @Query('index') String index,
  );

  @GET('/my/markets')
  Future<MarketListingResponse> getMyMarkets(
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('type') int type,
    @Query('status') int? status,
    @Query('sort') String sort,
    @Query('index') String index,
    @Query('q') String? query,
  );

  @GET('my/profile')
  Future<UserModel> getUser();
}
