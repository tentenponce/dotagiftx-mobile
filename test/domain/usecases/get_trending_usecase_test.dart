import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/data/responses/catalog_response.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_trending_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_trending_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxApi>()])
void main() {
  group(GetTrendingUsecaseImpl, () {
    late MockDotagiftxApi mockDotagiftxApi;
    late GetTrendingUsecaseImpl usecase;

    // Test data
    const testDotaItem1 = DotaItemModel(
      id: '1',
      name: 'Trending Item 1',
      hero: 'Trending Hero 1',
      rarity: 'rare',
      image: 'trending_image_1.png',
      lowestAsk: 15.5,
    );

    const testDotaItem2 = DotaItemModel(
      id: '2',
      name: 'Trending Item 2',
      hero: 'Trending Hero 2',
      rarity: 'ultra rare',
      image: 'trending_image_2.png',
      lowestAsk: 30.0,
    );

    setUp(() {
      mockDotagiftxApi = MockDotagiftxApi();
      usecase = GetTrendingUsecaseImpl(mockDotagiftxApi);
    });

    group('get', () {
      test('should return trending items successfully', () async {
        // Arrange
        const expectedItems = [testDotaItem1, testDotaItem2];
        const expectedResponse = CatalogResponse(
          data: expectedItems,
          totalCount: 2,
        );

        when(
          mockDotagiftxApi.getTrendingCatalogs(),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, equals(expectedItems));
        verify(mockDotagiftxApi.getTrendingCatalogs()).called(1);
      });
    });
  });
}
