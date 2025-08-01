import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/responses/market_listing_response.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_my_orders_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_my_orders_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxAuthApi>()])
void main() {
  group(GetMyOrdersUsecaseImpl, () {
    late MockDotagiftxAuthApi mockDotagiftxAuthApi;
    late GetMyOrdersUsecaseImpl usecase;

    // Test data
    const testMarketListing1 = MarketListingModel(
      id: '1',
      price: 10.0,
      inventoryStatus: 1,
      user: null,
    );

    const testMarketListing2 = MarketListingModel(
      id: '2',
      price: 20.0,
      inventoryStatus: 1,
      user: null,
    );

    setUp(() {
      mockDotagiftxAuthApi = MockDotagiftxAuthApi();
      usecase = GetMyOrdersUsecaseImpl(mockDotagiftxAuthApi);
    });

    group('get', () {
      test('should return my listings with default parameters', () async {
        // Arrange
        const expectedItems = [testMarketListing1, testMarketListing2];
        const expectedResponse = MarketListingResponse(
          data: expectedItems,
          totalCount: 2,
        );

        when(
          mockDotagiftxAuthApi.getMyMarkets(
            1,
            5,
            ApiConstants.queryMarketBid,
            ApiConstants.queryMarketStatusLive,
            ApiConstants.querySortUpdatedAtDesc,
            ApiConstants.queryIndexItemId,
            null,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await usecase.get(page: 1, limit: 5);

        // Assert
        expect(result, equals((expectedItems, 2)));
        verify(
          mockDotagiftxAuthApi.getMyMarkets(
            1,
            5,
            ApiConstants.queryMarketBid,
            ApiConstants.queryMarketStatusLive,
            ApiConstants.querySortUpdatedAtDesc,
            ApiConstants.queryIndexItemId,
            null,
          ),
        ).called(1);
      });

      test('should return my listings with custom parameters', () async {
        // Arrange
        const customLimit = 10;
        const customPage = 2;
        const customSearchQuery = 'test';
        const expectedItems = [testMarketListing1];
        const expectedResponse = MarketListingResponse(
          data: expectedItems,
          totalCount: 1,
        );

        when(
          mockDotagiftxAuthApi.getMyMarkets(
            customPage,
            customLimit,
            ApiConstants.queryMarketBid,
            ApiConstants.queryMarketStatusLive,
            ApiConstants.querySortUpdatedAtDesc,
            ApiConstants.queryIndexItemId,
            customSearchQuery,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await usecase.get(
          limit: customLimit,
          page: customPage,
          searchQuery: customSearchQuery,
        );

        // Assert
        expect(result, equals((expectedItems, 1)));
        verify(
          mockDotagiftxAuthApi.getMyMarkets(
            customPage,
            customLimit,
            ApiConstants.queryMarketBid,
            ApiConstants.queryMarketStatusLive,
            ApiConstants.querySortUpdatedAtDesc,
            ApiConstants.queryIndexItemId,
            customSearchQuery,
          ),
        ).called(1);
      });
    });
  });
}
