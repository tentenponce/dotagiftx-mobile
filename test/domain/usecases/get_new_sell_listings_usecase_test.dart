import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/responses/catalog_response.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_new_sell_listings_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_new_sell_listings_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxApi>()])
void main() {
  group(GetNewSellListingsUsecaseImpl, () {
    late MockDotagiftxApi mockDotagiftxApi;
    late GetNewSellListingsUsecaseImpl usecase;

    // Test data
    const testDotaItem1 = DotaItemModel(
      id: '1',
      name: 'Sell Listing Item 1',
      hero: 'Sell Listing Hero 1',
      rarity: 'rare',
      image: 'sell_listing_image_1.png',
      lowestAsk: 8.5,
    );

    const testDotaItem2 = DotaItemModel(
      id: '2',
      name: 'Sell Listing Item 2',
      hero: 'Sell Listing Hero 2',
      rarity: 'ultra rare',
      image: 'sell_listing_image_2.png',
      lowestAsk: 35.0,
    );

    setUp(() {
      mockDotagiftxApi = MockDotagiftxApi();
      usecase = GetNewSellListingsUsecaseImpl(mockDotagiftxApi);
    });

    group('get', () {
      test('should return sell listings with default parameters', () async {
        // Arrange
        const expectedItems = [testDotaItem1, testDotaItem2];
        const expectedResponse = CatalogResponse(
          data: expectedItems,
          totalCount: 2,
        );

        when(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortRecent,
            5, // default limit
            1, // default page
            '', // empty query
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, equals(expectedItems));
        verify(
          mockDotagiftxApi.getCatalogs(ApiConstants.querySortRecent, 5, 1, ''),
        ).called(1);
      });

      test('should return sell listings with custom parameters', () async {
        // Arrange
        const customLimit = 15;
        const customPage = 3;
        const expectedItems = [testDotaItem1];
        const expectedResponse = CatalogResponse(
          data: expectedItems,
          totalCount: 1,
        );

        when(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortRecent,
            customLimit,
            customPage,
            '',
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await usecase.get(limit: customLimit, page: customPage);

        // Assert
        expect(result, equals(expectedItems));
        verify(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortRecent,
            customLimit,
            customPage,
            '',
          ),
        ).called(1);
      });
    });
  });
}
