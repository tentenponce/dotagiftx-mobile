import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/responses/market_listing_response.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/models/steam_user_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_item_orders_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_dota_item_orders_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxApi>()])
void main() {
  group(GetDotaItemOrdersUsecaseImpl, () {
    late MockDotagiftxApi mockDotagiftxApi;
    late GetDotaItemOrdersUsecaseImpl usecase;

    const testItemId = 'test-item-id';
    const testLimit = 10;
    const testPage = 1;
    const testSort = ApiConstants.querySortHighest;
    const testTotalCount = 25;

    // Test data - Users
    const testUser1 = SteamUserModel(
      id: 'user1',
      name: 'Test User 1',
      avatar: 'https://example.com/avatar1.png',
      subscription: 1,
    );

    const testUser2 = SteamUserModel(
      id: 'user2',
      name: 'Test User 2',
      avatar: 'https://example.com/avatar2.png',
      subscription: null,
    );

    // Test data - Buy Orders
    const testBuyOrder1 = MarketListingModel(
      id: 'order1',
      price: 100.0,
      createdAt: '2023-01-01T00:00:00Z',
      inventoryStatus: 1,
      user: testUser1,
      resell: false,
    );

    const testBuyOrder2 = MarketListingModel(
      id: 'order2',
      price: 200.0,
      createdAt: '2023-01-02T00:00:00Z',
      inventoryStatus: 1,
      user: testUser2,
      resell: null,
    );

    final testBuyOrders = [testBuyOrder1, testBuyOrder2];

    setUp(() {
      mockDotagiftxApi = MockDotagiftxApi();
      usecase = GetDotaItemOrdersUsecaseImpl(mockDotagiftxApi);
    });

    group('get', () {
      test('should call API with default parameters', () async {
        // Arrange
        final mockResponse = MarketListingResponse(
          data: testBuyOrders,
          totalCount: testTotalCount,
        );

        when(
          mockDotagiftxApi.getMarkets(
            testItemId,
            testPage,
            testLimit,
            ApiConstants.queryMarketBid,
            ApiConstants.queryMarketStatusLive,
            null,
            ApiConstants.querySortHighest,
            ApiConstants.queryIndexItemId,
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await usecase.get(itemId: testItemId);

        // Assert
        expect(result.$1, equals(testBuyOrders));
        expect(result.$2, equals(testTotalCount));

        verify(
          mockDotagiftxApi.getMarkets(
            testItemId,
            1, // default page
            10, // default limit
            ApiConstants.queryMarketBid, // BID for buy orders
            ApiConstants.queryMarketStatusLive,
            null,
            ApiConstants.querySortHighest, // default sort
            ApiConstants.queryIndexItemId,
          ),
        ).called(1);
      });

      test('should call API with custom parameters', () async {
        // Arrange
        const customLimit = 20;
        const customPage = 2;
        const customSort = ApiConstants.querySortRecent;

        final mockResponse = MarketListingResponse(
          data: testBuyOrders,
          totalCount: testTotalCount,
        );

        when(
          mockDotagiftxApi.getMarkets(
            testItemId,
            customPage,
            customLimit,
            ApiConstants.queryMarketBid,
            ApiConstants.queryMarketStatusLive,
            null,
            customSort,
            ApiConstants.queryIndexItemId,
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await usecase.get(
          itemId: testItemId,
          limit: customLimit,
          page: customPage,
          sort: customSort,
        );

        // Assert
        expect(result.$1, equals(testBuyOrders));
        expect(result.$2, equals(testTotalCount));

        verify(
          mockDotagiftxApi.getMarkets(
            testItemId,
            customPage,
            customLimit,
            ApiConstants.queryMarketBid, // BID for buy orders
            ApiConstants.queryMarketStatusLive,
            null,
            customSort,
            ApiConstants.queryIndexItemId,
          ),
        ).called(1);
      });

      test('should return empty list when API returns empty data', () async {
        // Arrange
        const mockResponse = MarketListingResponse(
          data: <MarketListingModel>[],
          totalCount: 0,
        );

        when(
          mockDotagiftxApi.getMarkets(
            testItemId,
            testPage,
            testLimit,
            ApiConstants.queryMarketBid,
            ApiConstants.queryMarketStatusLive,
            null,
            testSort,
            ApiConstants.queryIndexItemId,
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await usecase.get(itemId: testItemId);

        // Assert
        expect(result.$1, isEmpty);
        expect(result.$2, equals(0));
      });

      test('should propagate API exceptions', () async {
        // Arrange
        when(
          mockDotagiftxApi.getMarkets(
            testItemId,
            testPage,
            testLimit,
            ApiConstants.queryMarketBid,
            ApiConstants.queryMarketStatusLive,
            null,
            testSort,
            ApiConstants.queryIndexItemId,
          ),
        ).thenThrow(Exception('API Error'));

        // Act & Assert
        expect(
          () async => usecase.get(itemId: testItemId),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
