import 'package:dio/dio.dart' hide Headers;
import 'package:dotagiftx_mobile/data/core/dio/dio_provider.dart';
import 'package:dotagiftx_mobile/data/requests/refresh_token_request.dart';
import 'package:dotagiftx_mobile/data/requests/revoke_token_request.dart';
import 'package:dotagiftx_mobile/data/responses/catalog_response.dart';
import 'package:dotagiftx_mobile/data/responses/login_response.dart';
import 'package:dotagiftx_mobile/data/responses/market_summary_response.dart';
import 'package:dotagiftx_mobile/data/responses/refresh_token_response.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
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

  @GET('/catalogs')
  Future<CatalogResponse> getCatalogs(
    @Query('sort') String sort,
    @Query('limit') int limit,
    @Query('page') int page,
    @Query('q') String? search,
  );

  @GET('stats/market_summary')
  Future<MarketSummaryResponse> getMarketSummary(
    @Query('partner_steam_id') String? partnerSteamId,
    @Query('user_id') String? userId,
  );

  @GET('/catalogs_trend')
  Future<CatalogResponse> getTrendingCatalogs();

  @GET('auth/steam?{openIdQueryParams}')
  Future<LoginResponse> loginSteam(@Path('openIdQueryParams') String openid);

  @POST('auth/renew')
  Future<RefreshTokenResponse> refreshToken(
    @Body() RefreshTokenRequest request,
  );

  @POST('auth/revoke')
  Future<void> revokeToken(@Body() RevokeTokenRequest request);
}
