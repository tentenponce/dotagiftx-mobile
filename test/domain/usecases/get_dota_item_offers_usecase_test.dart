import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/responses/market_listing_response.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_item_offers_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_dota_item_offers_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxApi>()])
void main() {
  group(GetDotaItemOffersUsecaseImpl, () {
    late MockDotagiftxApi mockDotagiftxApi;
    late GetDotaItemOffersUsecaseImpl usecase;

    // Test data
    const testUser1 = UserModel(
      id: 'user1',
      name: 'Test User 1',
      avatar: 'https://example.com/avatar1.png',
      subscription: 1,
    );

    const testUser2 = UserModel(
      id: 'user2',
      name: 'Test User 2',
      avatar: 'https://example.com/avatar2.png',
      subscription: 0,
    );

    const testOffer1 = MarketListingModel(
      id: 'offer1',
      price: 100.0,
      createdAt: '2023-01-01T00:00:00Z',
      inventoryStatus: 1,
      user: testUser1,
    );

    const testOffer2 = MarketListingModel(
      id: 'offer2',
      price: 200.0,
      createdAt: '2023-01-02T00:00:00Z',
      inventoryStatus: 1,
      user: testUser2,
    );

    const testItemId = 'test-item-id';

    setUp(() {
      mockDotagiftxApi = MockDotagiftxApi();
      usecase = GetDotaItemOffersUsecaseImpl(mockDotagiftxApi);
    });

    group('get', () {
      test(
        'should return offers successfully with default parameters',
        () async {
          // Arrange
          const expectedOffers = [testOffer1, testOffer2];
          const expectedTotalCount = 10;
          const expectedResponse = MarketListingResponse(
            data: expectedOffers,
            totalCount: expectedTotalCount,
          );

          when(
            mockDotagiftxApi.getMarkets(
              testItemId,
              1, // default page
              10, // default limit
              ApiConstants.queryMarketAsk,
              ApiConstants.queryMarketStatusLive,
              ApiConstants.queryInventoryStatusVerified,
              ApiConstants.querySortLowest, // default sort
              ApiConstants.queryIndexItemId,
            ),
          ).thenAnswer((_) async => expectedResponse);

          // Act
          final result = await usecase.get(itemId: testItemId);

          // Assert
          expect(result.$1, equals(expectedOffers));
          expect(result.$2, equals(expectedTotalCount));
          verify(
            mockDotagiftxApi.getMarkets(
              testItemId,
              1,
              10,
              ApiConstants.queryMarketAsk,
              ApiConstants.queryMarketStatusLive,
              ApiConstants.queryInventoryStatusVerified,
              ApiConstants.querySortLowest,
              ApiConstants.queryIndexItemId,
            ),
          ).called(1);
        },
      );

      test(
        'should return offers successfully with custom parameters',
        () async {
          // Arrange
          const expectedOffers = [testOffer1];
          const expectedTotalCount = 5;
          const expectedResponse = MarketListingResponse(
            data: expectedOffers,
            totalCount: expectedTotalCount,
          );
          const customLimit = 5;
          const customPage = 2;
          const customSort = ApiConstants.querySortRecent;

          when(
            mockDotagiftxApi.getMarkets(
              testItemId,
              customPage,
              customLimit,
              ApiConstants.queryMarketAsk,
              ApiConstants.queryMarketStatusLive,
              ApiConstants.queryInventoryStatusVerified,
              customSort,
              ApiConstants.queryIndexItemId,
            ),
          ).thenAnswer((_) async => expectedResponse);

          // Act
          final result = await usecase.get(
            itemId: testItemId,
            limit: customLimit,
            page: customPage,
            sort: customSort,
          );

          // Assert
          expect(result.$1, equals(expectedOffers));
          expect(result.$2, equals(expectedTotalCount));
          verify(
            mockDotagiftxApi.getMarkets(
              testItemId,
              customPage,
              customLimit,
              ApiConstants.queryMarketAsk,
              ApiConstants.queryMarketStatusLive,
              ApiConstants.queryInventoryStatusVerified,
              customSort,
              ApiConstants.queryIndexItemId,
            ),
          ).called(1);
        },
      );

      test('should return empty list when no offers available', () async {
        // Arrange
        const expectedOffers = <MarketListingModel>[];
        const expectedTotalCount = 0;
        const expectedResponse = MarketListingResponse(
          data: expectedOffers,
          totalCount: expectedTotalCount,
        );

        when(
          mockDotagiftxApi.getMarkets(
            testItemId,
            1,
            10,
            ApiConstants.queryMarketAsk,
            ApiConstants.queryMarketStatusLive,
            ApiConstants.queryInventoryStatusVerified,
            ApiConstants.querySortLowest,
            ApiConstants.queryIndexItemId,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await usecase.get(itemId: testItemId);

        // Assert
        expect(result.$1, isEmpty);
        expect(result.$2, equals(0));
        verify(
          mockDotagiftxApi.getMarkets(
            testItemId,
            1,
            10,
            ApiConstants.queryMarketAsk,
            ApiConstants.queryMarketStatusLive,
            ApiConstants.queryInventoryStatusVerified,
            ApiConstants.querySortLowest,
            ApiConstants.queryIndexItemId,
          ),
        ).called(1);
      });
    });
  });
}
