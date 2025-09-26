import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/responses/dota_items_response.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_items_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_dota_items_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxUnauthApi>()])
void main() {
  group(GetDotaItemsUsecaseImpl, () {
    late MockDotagiftxUnauthApi mockDotagiftxUnauthApi;

    // Test data
    const testItem1 = DotaItemModel(
      id: 'item-1',
      name: 'Arcana of the Ancients',
      hero: 'Pudge',
      rarity: 'mythical',
      slug: 'arcana-of-the-ancients',
      lowestAsk: 25.99,
      highestBid: 23.50,
      origin: 'Treasure Chest',
      reservedCount: 5,
      soldCount: 150,
    );

    const testItem2 = DotaItemModel(
      id: 'item-2',
      name: 'Immortal Blade',
      hero: 'Invoker',
      rarity: 'immortal',
      slug: 'immortal-blade',
      lowestAsk: 15.75,
      highestBid: 14.25,
      origin: 'Battle Pass',
      reservedCount: 2,
      soldCount: 89,
    );

    const testItem3 = DotaItemModel(
      id: 'item-3',
      name: 'Common Sword',
      hero: 'Sven',
      rarity: 'common',
      slug: 'common-sword',
      lowestAsk: 0.99,
      highestBid: 0.75,
      origin: 'Drop',
      reservedCount: 0,
      soldCount: 25,
    );

    const testItemWithNullFields = DotaItemModel(
      id: 'item-4',
      name: null,
      hero: null,
      rarity: null,
      slug: null,
      lowestAsk: null,
      highestBid: null,
      origin: null,
      reservedCount: null,
      soldCount: null,
    );

    const testItems = [testItem1, testItem2, testItem3];
    const testItemsWithNulls = [testItem1, testItemWithNullFields, testItem2];

    setUp(() {
      mockDotagiftxUnauthApi = MockDotagiftxUnauthApi();
    });

    GetDotaItemsUsecaseImpl createUnitToTest() {
      return GetDotaItemsUsecaseImpl(mockDotagiftxUnauthApi);
    }

    group('get', () {
      test('should fetch dota items successfully', () async {
        // Arrange
        const response = DotaItemsResponse(data: testItems, totalCount: 3);

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, equals(testItems));
        expect(result.length, equals(3));
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should return empty list when API returns no items', () async {
        // Arrange
        const response = DotaItemsResponse(
          data: <DotaItemModel>[],
          totalCount: 0,
        );

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, isEmpty);
        expect(result.length, equals(0));
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should handle single item response', () async {
        // Arrange
        const singleItemList = [testItem1];
        const response = DotaItemsResponse(data: singleItemList, totalCount: 1);

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, equals(singleItemList));
        expect(result.length, equals(1));
        expect(result.first, equals(testItem1));
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should handle items with null fields', () async {
        // Arrange
        const response = DotaItemsResponse(
          data: testItemsWithNulls,
          totalCount: 3,
        );

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, equals(testItemsWithNulls));
        expect(result.length, equals(3));
        expect(result.elementAt(1), equals(testItemWithNullFields));
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should handle large number of items', () async {
        // Arrange
        final largeItemList = List.generate(
          500,
          (index) => DotaItemModel(
            id: 'item-$index',
            name: 'Item $index',
            hero: 'Hero $index',
            rarity: 'common',
            slug: 'item-$index',
          ),
        );

        final response = DotaItemsResponse(
          data: largeItemList,
          totalCount: 500,
        );

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, equals(largeItemList));
        expect(result.length, equals(500));
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should use correct API parameters', () async {
        // Arrange
        const response = DotaItemsResponse(data: testItems, totalCount: 3);

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        await usecase.get();

        // Assert - Verify the exact parameters are used
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000, // limit
            'true', // active as string
            'created_at:desc', // sort parameter
          ),
        ).called(1);
      });

      test('should ignore totalCount from response', () async {
        // Arrange - totalCount doesn't match actual data length
        const response = DotaItemsResponse(
          data: testItems, // 3 items
          totalCount: 999, // Different total count
        );

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        final result = await usecase.get();

        // Assert - Should return actual data, not be affected by totalCount
        expect(result, equals(testItems));
        expect(result.length, equals(3)); // Actual data length, not totalCount
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should handle API exception', () async {
        // Arrange
        final exception = Exception('Network error');

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(usecase.get, throwsA(equals(exception)));

        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should handle timeout exception', () async {
        // Arrange
        final timeoutException = Exception('Request timeout');

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenThrow(timeoutException);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(usecase.get, throwsA(equals(timeoutException)));

        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should handle server error exception', () async {
        // Arrange
        final serverException = Exception('Internal server error');

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenThrow(serverException);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(usecase.get, throwsA(equals(serverException)));

        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });
    });

    group('edge cases and boundary conditions', () {
      test(
        'should handle response with maximum expected items (1000)',
        () async {
          // Arrange
          final maxItems = List.generate(
            1000,
            (index) =>
                DotaItemModel(id: 'max-item-$index', name: 'Max Item $index'),
          );

          final response = DotaItemsResponse(data: maxItems, totalCount: 1000);

          when(
            mockDotagiftxUnauthApi.getDotaItems(
              1000,
              'true',
              ApiConstants.querySortCreatedAtDesc,
            ),
          ).thenAnswer((_) async => response);

          final usecase = createUnitToTest();

          // Act
          final result = await usecase.get();

          // Assert
          expect(result, equals(maxItems));
          expect(result.length, equals(1000));
          verify(
            mockDotagiftxUnauthApi.getDotaItems(
              1000,
              'true',
              ApiConstants.querySortCreatedAtDesc,
            ),
          ).called(1);
        },
      );

      test('should handle items with extreme price values', () async {
        // Arrange
        const extremeItems = [
          DotaItemModel(
            id: 'free-item',
            name: 'Free Item',
            lowestAsk: 0.0,
            highestBid: 0.0,
          ),
          DotaItemModel(
            id: 'expensive-item',
            name: 'Ultra Rare Item',
            lowestAsk: 999999.99,
            highestBid: 888888.88,
          ),
          DotaItemModel(
            id: 'micro-price-item',
            name: 'Penny Item',
            lowestAsk: 0.01,
            highestBid: 0.005,
          ),
        ];

        const response = DotaItemsResponse(data: extremeItems, totalCount: 3);

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, equals(extremeItems));
        expect(result.length, equals(3));
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });

      test('should handle items with extreme count values', () async {
        // Arrange
        const extremeCountItems = [
          DotaItemModel(
            id: 'no-activity-item',
            name: 'No Activity Item',
            reservedCount: 0,
            soldCount: 0,
          ),
          DotaItemModel(
            id: 'high-activity-item',
            name: 'Popular Item',
            reservedCount: 999999,
            soldCount: 1000000,
          ),
        ];

        const response = DotaItemsResponse(
          data: extremeCountItems,
          totalCount: 2,
        );

        when(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).thenAnswer((_) async => response);

        final usecase = createUnitToTest();

        // Act
        final result = await usecase.get();

        // Assert
        expect(result, equals(extremeCountItems));
        expect(result.length, equals(2));
        verify(
          mockDotagiftxUnauthApi.getDotaItems(
            1000,
            'true',
            ApiConstants.querySortCreatedAtDesc,
          ),
        ).called(1);
      });
    });
  });
}
