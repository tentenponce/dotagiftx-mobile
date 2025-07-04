import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/responses/catalog_response.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/search_catalog_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_catalog_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxApi>()])
void main() {
  group(SearchCatalogUsecaseImpl, () {
    late MockDotagiftxApi mockDotagiftxApi;
    late SearchCatalogUsecaseImpl usecase;

    // Test data
    const testDotaItem1 = DotaItemModel(
      id: '1',
      name: 'Test Item 1',
      hero: 'Test Hero 1',
      rarity: 'rare',
      image: 'test_image_1.png',
      lowestAsk: 10.5,
    );

    const testDotaItem2 = DotaItemModel(
      id: '2',
      name: 'Test Item 2',
      hero: 'Test Hero 2',
      rarity: 'ultra rare',
      image: 'test_image_2.png',
      lowestAsk: 25.0,
    );

    setUp(() {
      mockDotagiftxApi = MockDotagiftxApi();
      usecase = SearchCatalogUsecaseImpl(mockDotagiftxApi);
    });

    group('search', () {
      test('should return search results with default parameters', () async {
        // Arrange
        const query = 'test query';
        const expectedItems = [testDotaItem1, testDotaItem2];
        const expectedTotalCount = 25;
        const expectedResponse = CatalogResponse(
          data: expectedItems,
          totalCount: expectedTotalCount,
        );

        when(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortPopular,
            10, // default limit
            1, // default page
            query,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await usecase.search(query: query);

        // Assert
        expect(result.$1, equals(expectedItems));
        expect(result.$2, equals(expectedTotalCount));
        verify(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortPopular,
            10,
            1,
            query,
          ),
        ).called(1);
      });

      test('should return search results with custom parameters', () async {
        // Arrange
        const query = 'custom query';
        const customLimit = 20;
        const customPage = 3;
        const expectedItems = [testDotaItem1];
        const expectedTotalCount = 50;
        const expectedResponse = CatalogResponse(
          data: expectedItems,
          totalCount: expectedTotalCount,
        );

        when(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortPopular,
            customLimit,
            customPage,
            query,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await usecase.search(
          query: query,
          limit: customLimit,
          page: customPage,
        );

        // Assert
        expect(result.$1, equals(expectedItems));
        expect(result.$2, equals(expectedTotalCount));
        verify(
          mockDotagiftxApi.getCatalogs(
            ApiConstants.querySortPopular,
            customLimit,
            customPage,
            query,
          ),
        ).called(1);
      });
    });
  });
}
