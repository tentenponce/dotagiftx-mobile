import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/responses/catalog_response.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_new_buy_orders_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_new_buy_orders_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxApi>()])
void main() {
  group(GetNewBuyOrdersUsecaseImpl, () {
    late MockDotagiftxApi mockDotagiftxApi;
    late GetNewBuyOrdersUsecaseImpl usecase;

    // Test data
    const testDotaItem1 = DotaItemModel(
      id: '1',
      name: 'Buy Order Item 1',
      hero: 'Buy Order Hero 1',
      rarity: 'rare',
      image: 'buy_order_image_1.png',
      lowestAsk: 12.5,
    );

    const testDotaItem2 = DotaItemModel(
      id: '2',
      name: 'Buy Order Item 2',
      hero: 'Buy Order Hero 2',
      rarity: 'very rare',
      image: 'buy_order_image_2.png',
      lowestAsk: 20.0,
    );

    setUp(() {
      mockDotagiftxApi = MockDotagiftxApi();
      usecase = GetNewBuyOrdersUsecaseImpl(mockDotagiftxApi);
    });

    group('get', () {
      test('should return buy orders with default parameters', () async {
        // Arrange
        const expectedItems = [testDotaItem1, testDotaItem2];
        const expectedResponse = CatalogResponse(
          data: expectedItems,
          totalCount: 2,
        );

        when(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortRecentBid,
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
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortRecentBid,
            5,
            1,
            '',
          ),
        ).called(1);
      });

      test('should return buy orders with custom parameters', () async {
        // Arrange
        const customLimit = 10;
        const customPage = 2;
        const expectedItems = [testDotaItem1];
        const expectedResponse = CatalogResponse(
          data: expectedItems,
          totalCount: 1,
        );

        when(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortRecentBid,
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
            ApiConstants.querySortRecentBid,
            customLimit,
            customPage,
            '',
          ),
        ).called(1);
      });
    });
  });
}
