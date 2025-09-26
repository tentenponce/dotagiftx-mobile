import 'package:dio/dio.dart' hide Headers;
import 'package:dotagiftx_mobile/data/core/dio/dio_provider.dart';
import 'package:dotagiftx_mobile/data/requests/refresh_token_request.dart';
import 'package:dotagiftx_mobile/data/requests/revoke_token_request.dart';
import 'package:dotagiftx_mobile/data/responses/catalog_response.dart';
import 'package:dotagiftx_mobile/data/responses/dota_items_response.dart';
import 'package:dotagiftx_mobile/data/responses/login_response.dart';
import 'package:dotagiftx_mobile/data/responses/market_summary_response.dart';
import 'package:dotagiftx_mobile/data/responses/refresh_token_response.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'dotagiftx_unauth_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class DotagiftxUnauthApi {
  @factoryMethod
  factory DotagiftxUnauthApi(
    UnauthDioProviderImpl dioProvider,
    @baseUrl String baseUrl,
  ) => _DotagiftxUnauthApi(
    dioProvider.create<DotagiftxUnauthApi>(),
    baseUrl: baseUrl,
  );

  @GET('/catalogs/{slug}')
  Future<DotaItemModel> getCatalogBySlug(@Path('slug') String slug);

  @GET('/catalogs')
  Future<CatalogResponse> getCatalogs(
    @Query('sort') String sort,
    @Query('limit') int limit,
    @Query('page') int page,
    @Query('q') String? search,
  );

  @GET('/items')
  Future<DotaItemsResponse> getDotaItems(
    @Query('limit') int limit,
    @Query('active') String? active,
    @Query('sort') String sort,
  );

  @GET('stats/market_summary')
  Future<MarketSummaryResponse> getPartnerMarketSummary(
    @Query('partner_steam_id') String partnerSteamId,
  );

  @GET('/catalogs_trend')
  Future<CatalogResponse> getTrendingCatalogs();

  @GET('stats/market_summary')
  Future<MarketSummaryResponse> getUserMarketSummary(
    @Query('user_id') String userId,
    @Query('index') String? index,
  );

  @GET('auth/steam?{openIdQueryParams}')
  Future<LoginResponse> loginSteam(@Path('openIdQueryParams') String openid);

  @POST('auth/renew')
  Future<RefreshTokenResponse> refreshToken(
    @Body() RefreshTokenRequest request,
  );

  @POST('auth/revoke')
  Future<void> revokeToken(@Body() RevokeTokenRequest request);
}
