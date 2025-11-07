import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/data/local/listen_local_storage.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_items_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/post_listing_usecase.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_item_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<DotagiftxUnauthApi>(),
  MockSpec<GetDotaItemsUsecase>(),
  MockSpec<PostListingUsecase>(),
  MockSpec<ListenLocalStorage>(),
])
void main() {
  group(PostItemCubit, () {
    late MockLogger mockLogger;
    late MockDotagiftxUnauthApi mockDotagiftxUnauthApi;
    late MockGetDotaItemsUsecase mockGetDotaItemsUsecase;
    late MockPostListingUsecase mockPostListingUsecase;
    late MockListenLocalStorage mockListenLocalStorage;
    late bool showSuccessPostCalled;
    late bool showInvalidQuantityErrorCalled;
    late int setQuantityValue;

    // Test data
    const testItem1 = DotaItemModel(
      id: 'item-1',
      name: 'Test Item 1',
      hero: 'Pudge',
      slug: 'test-item-1',
      rarity: 'mythical',
    );

    const testItem2 = DotaItemModel(
      id: 'item-2',
      name: 'Test Item 2',
      hero: 'Invoker',
      slug: 'test-item-2',
      rarity: 'immortal',
    );

    const testItem3 = DotaItemModel(
      id: 'item-3',
      name: 'Another Item',
      hero: 'Pudge',
      slug: 'another-item',
      rarity: 'rare',
    );

    const testItemWithNullFields = DotaItemModel(
      id: 'item-4',
      name: null,
      hero: null,
      slug: 'item-with-nulls',
    );

    const testUpdatedItem = DotaItemModel(
      id: 'item-1',
      name: 'Updated Test Item 1',
      hero: 'Pudge',
      slug: 'test-item-1',
      rarity: 'mythical',
      lowestAsk: 10.5,
      highestBid: 8.0,
    );

    const testItems = [testItem1, testItem2, testItem3];
    const testApiErrorMessage = 'API Error: Test error message';

    const testUserModel = UserModel(
      name: 'Test User',
      url: 'https://steamcommunity.com/profiles/12345',
      avatar: 'https://example.com/avatar.png',
      createdAt: '2024-01-01T00:00:00Z',
      marketStats: MarketStats(live: 5, reserved: 2, sold: 10, bidCompleted: 3),
      subscription: 1,
      subscribedAt: '2024-01-01T00:00:00Z',
    );

    setUp(() {
      mockLogger = MockLogger();
      mockDotagiftxUnauthApi = MockDotagiftxUnauthApi();
      mockGetDotaItemsUsecase = MockGetDotaItemsUsecase();
      mockPostListingUsecase = MockPostListingUsecase();
      mockListenLocalStorage = MockListenLocalStorage();
      showSuccessPostCalled = false;
      showInvalidQuantityErrorCalled = false;
      setQuantityValue = 0;
    });

    PostItemCubit createUnitToTest() {
      final cubit = PostItemCubit(
        mockLogger,
        mockGetDotaItemsUsecase,
        mockDotagiftxUnauthApi,
        mockPostListingUsecase,
        mockListenLocalStorage,
      );

      // Set up callback functions
      cubit.showSuccessPost = () {
        showSuccessPostCalled = true;
      };
      cubit.setQuantity = (quantity) {
        setQuantityValue = quantity;
      };
      cubit.showInvalidQuantityError = () {
        showInvalidQuantityErrorCalled = true;
      };

      return cubit;
    }

    test('should listen user if logged in', () async {
      when(
        mockListenLocalStorage.listenUser(),
      ).thenAnswer((_) => Stream.value(testUserModel));

      final cubit = createUnitToTest();
      await Future<void>.delayed(Duration.zero);

      verify(mockListenLocalStorage.listenUser()).called(1);
      expect(cubit.state.isUserLoggedIn, isTrue);
    });

    group('logger', () {
      test('should return the injected logger', () {
        // Arrange
        final cubit = createUnitToTest();

        // Act & Assert
        expect(cubit.logger, equals(mockLogger));
      });
    });

    group('price setter', () {
      test('should update price and clear error when price is not empty', () {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.price = '10.5';

        // Assert
        expect(cubit.price, equals('10.5'));
        expect(cubit.state.isPriceErrorRequired, isFalse);
      });

      test('should update price and set error when price is empty', () {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.price = '';

        // Assert
        expect(cubit.price, isEmpty);
        expect(cubit.state.isPriceErrorRequired, isTrue);
      });
    });

    group('init', () {
      test('should load dota items successfully', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        // Act
        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Assert
        verify(mockGetDotaItemsUsecase.get()).called(1);
        expect(cubit.state.items, equals(testItems));
        expect(cubit.state.isGetItemsLoading, isFalse);
      });

      test('should handle error when loading dota items', () async {
        // Arrange
        when(
          mockGetDotaItemsUsecase.get(),
        ).thenThrow(Exception('Failed to load items'));

        // Act
        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Assert
        verify(mockGetDotaItemsUsecase.get()).called(1);
        expect(cubit.state.isGetItemsLoading, isFalse);
        verify(mockLogger.log(LogLevel.error, any, any, any)).called(1);
      });

      test('should set loading state correctly during item loading', () async {
        // Arrange
        final completer = Completer<List<DotaItemModel>>();
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) => completer.future);

        final states = <bool>[];

        // Act
        final cubit = createUnitToTest();
        cubit.stream.listen((state) {
          states.add(state.isGetItemsLoading);
        });

        await Future<void>.delayed(Duration.zero);

        // Complete the loading
        completer.complete(testItems);
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states, contains(true));
        expect(states.last, isFalse);
      });
    });

    group('clearSelectedItem', () {
      test('should clear selected item and set error', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete
        cubit.selectItem(testItem1);

        // Act
        cubit.clearSelectedItem();

        // Assert
        expect(cubit.state.selectedItem, isNull);
        expect(cubit.state.isItemErrorRequired, isTrue);
        expect(cubit.state.items, equals(testItems));
      });
    });

    group('filterItems', () {
      test('should show all items when query is empty', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.filterItems('');

        // Assert
        expect(cubit.state.items, equals(testItems));
        expect(cubit.state.selectedItem, isNull);
        expect(cubit.state.isItemErrorRequired, isFalse);
      });

      test('should filter items by hero and name', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.filterItems('Pudge');

        // Assert
        expect(cubit.state.items.length, equals(2));
        expect(cubit.state.items, contains(testItem1));
        expect(cubit.state.items, contains(testItem3));
        expect(cubit.state.selectedItem, isNull);
        expect(cubit.state.isItemErrorRequired, isFalse);
      });

      test('should perform case-insensitive search', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.filterItems('PUDGE');

        // Assert
        expect(cubit.state.items.length, equals(2));
        expect(cubit.state.items, contains(testItem1));
        expect(cubit.state.items, contains(testItem3));
      });

      test('should search by item name', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.filterItems('Another');

        // Assert
        expect(cubit.state.items.length, equals(1));
        expect(cubit.state.items, contains(testItem3));
      });

      test('should return empty results when no matches found', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.filterItems('NonExistent');

        // Assert
        expect(cubit.state.items, isEmpty);
      });

      test('should handle items with null hero and name safely', () async {
        // Arrange
        final itemsWithNulls = [...testItems, testItemWithNullFields];
        when(
          mockGetDotaItemsUsecase.get(),
        ).thenAnswer((_) async => itemsWithNulls);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.filterItems('Test');

        // Assert
        expect(cubit.state.items.length, equals(2));
        expect(cubit.state.items, contains(testItem1));
        expect(cubit.state.items, contains(testItem2));
        expect(cubit.state.items, isNot(contains(testItemWithNullFields)));
      });
    });

    group('selectItem', () {
      test('should select item and clear error', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).thenAnswer((_) async => testUpdatedItem);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.selectItem(testItem1);

        // Assert
        expect(cubit.state.selectedItem, equals(testItem1));
        expect(cubit.state.isItemErrorRequired, isFalse);
        expect(cubit.state.items, equals(testItems));
      });

      test('should update selected item with catalog data', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).thenAnswer((_) async => testUpdatedItem);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.selectItem(testItem1);
        await Future<void>.delayed(
          Duration.zero,
        ); // Allow catalog call to complete

        // Assert
        verify(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).called(1);
        expect(cubit.state.selectedItem, equals(testUpdatedItem));
      });

      test('should handle error when fetching catalog data', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).thenThrow(Exception('Failed to fetch catalog'));

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero);

        // Act
        cubit.selectItem(testItem1);
        await Future<void>.delayed(Duration.zero);

        // Assert
        verify(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).called(1);
        expect(
          cubit.state.selectedItem,
          equals(testItem1),
        ); // Should remain original item
        verify(mockLogger.log(LogLevel.error, any, any, any)).called(1);
      });

      test('should handle item with null slug', () async {
        // Arrange
        const itemWithNullSlug = DotaItemModel(
          id: 'item-null-slug',
          name: 'Item with null slug',
          slug: null,
        );

        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockDotagiftxUnauthApi.getCatalogBySlug(''),
        ).thenAnswer((_) async => itemWithNullSlug);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.selectItem(itemWithNullSlug);

        // Assert
        expect(cubit.state.selectedItem, equals(itemWithNullSlug));
        expect(cubit.state.isItemErrorRequired, isFalse);
      });
    });

    group('postItem', () {
      test('should post item successfully', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 2,
            notes: 'test notes',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        cubit.selectItem(testItem1);
        cubit.price = '10.5';
        cubit.quantity = '2';
        cubit.notes = 'test notes';

        // Act
        await cubit.postItem();

        // Assert
        expect(cubit.state.isPostItemLoading, isFalse);
        expect(showSuccessPostCalled, isTrue);
        verify(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 2,
            notes: 'test notes',
          ),
        ).called(1);
      });

      test('should set quantity to 1 when quantity is 0 or negative', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 1,
            notes: '',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        cubit.selectItem(testItem1);
        cubit.price = '10.5';
        cubit.quantity = '0';

        // Act
        await cubit.postItem();

        // Assert
        expect(setQuantityValue, equals(1));
        verify(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 1,
            notes: '',
          ),
        ).called(1);
      });

      test('should show errors when item is not selected', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.price = '10.5';

        // Act
        await cubit.postItem();

        // Assert
        expect(cubit.state.isItemErrorRequired, isTrue);
        expect(cubit.state.isPriceErrorRequired, isFalse);
        expect(cubit.state.isPostItemLoading, isFalse);
        verifyNever(
          mockPostListingUsecase.post(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            quantity: anyNamed('quantity'),
            notes: anyNamed('notes'),
          ),
        );
      });

      test('should show errors when price is 0 or negative', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        cubit.selectItem(testItem1);
        cubit.price = '0';

        // Act
        await cubit.postItem();

        // Assert
        expect(cubit.state.isItemErrorRequired, isFalse);
        expect(cubit.state.isPriceErrorRequired, isTrue);
        expect(cubit.state.isPostItemLoading, isFalse);
        verifyNever(
          mockPostListingUsecase.post(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            quantity: anyNamed('quantity'),
            notes: anyNamed('notes'),
          ),
        );
      });

      test('should show errors when both item and price are invalid', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.price = '-5';

        // Act
        await cubit.postItem();

        // Assert
        expect(cubit.state.isItemErrorRequired, isTrue);
        expect(cubit.state.isPriceErrorRequired, isTrue);
        expect(cubit.state.isPostItemLoading, isFalse);
        verifyNever(
          mockPostListingUsecase.post(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            quantity: anyNamed('quantity'),
            notes: anyNamed('notes'),
          ),
        );
      });

      test('should handle invalid price format', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        cubit.selectItem(testItem1);
        cubit.price = 'invalid';

        // Act
        await cubit.postItem();

        // Assert
        expect(cubit.state.isPriceErrorRequired, isTrue);
        verifyNever(
          mockPostListingUsecase.post(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            quantity: anyNamed('quantity'),
            notes: anyNamed('notes'),
          ),
        );
      });

      test('should handle invalid quantity format', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 1, // Invalid quantity 'invalid' parses to 1
            notes: '',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        cubit.selectItem(testItem1);
        cubit.price = '10.5';
        cubit.quantity = 'invalid';

        // Act
        await cubit.postItem();

        // Assert
        expect(setQuantityValue, equals(1)); // setQuantity is called with 1
        verify(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 1, // But API call still uses parsed quantity 1
            notes: '',
          ),
        ).called(1);
      });

      test('should set loading state during post item', () async {
        // Arrange
        final completer = Completer<void>();
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 1,
            notes: '',
          ),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        cubit.selectItem(testItem1);
        cubit.price = '10.5';

        // Act
        final postFuture = cubit.postItem();

        // Assert loading state
        expect(cubit.state.isPostItemLoading, isTrue);

        // Complete the post
        completer.complete();
        await postFuture;

        // Assert final state
        expect(cubit.state.isPostItemLoading, isFalse);
      });

      test('should handle invalid quantity exception', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 1,
            notes: '',
          ),
        ).thenThrow(InvalidQuantityException());

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        cubit.selectItem(testItem1);
        cubit.price = '10.5';

        // Act
        await cubit.postItem();

        // Assert
        expect(cubit.state.isPostItemLoading, isFalse);
        expect(showSuccessPostCalled, isFalse);
        expect(showInvalidQuantityErrorCalled, isTrue);
        verify(mockLogger.log(LogLevel.error, any, any, any)).called(1);
      });

      test(
        'should handle BadRequestException with API error message',
        () async {
          // Arrange
          final exception = BadRequestException(
            error: DioException(requestOptions: RequestOptions()),
            apiErrorMessage: testApiErrorMessage,
            statusCode: 400,
          );

          when(
            mockGetDotaItemsUsecase.get(),
          ).thenAnswer((_) async => testItems);
          when(
            mockPostListingUsecase.post(
              itemId: 'item-1',
              price: 10.5,
              quantity: 1,
              notes: '',
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();
          await Future<void>.delayed(Duration.zero); // Allow init to complete

          cubit.selectItem(testItem1);
          cubit.price = '10.5';

          // Act
          await cubit.postItem();

          // Assert
          expect(cubit.state.isPostItemLoading, isFalse);
          expect(showSuccessPostCalled, isFalse);
          verify(mockLogger.log(LogLevel.error, any, any, any)).called(1);
        },
      );

      test('should handle generic exception', () async {
        // Arrange
        final exception = Exception('Generic error');

        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 10.5,
            quantity: 1,
            notes: '',
          ),
        ).thenThrow(exception);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        cubit.selectItem(testItem1);
        cubit.price = '10.5';

        // Act
        await cubit.postItem();

        // Assert
        expect(cubit.state.isPostItemLoading, isFalse);
        expect(showSuccessPostCalled, isFalse);
        verify(mockLogger.log(LogLevel.error, any, any, any)).called(1);
      });
    });

    test(
      'preselectItem should set selectedItem and fetch catalog data',
      () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).thenAnswer((_) async => testUpdatedItem);

        final cubit = createUnitToTest();

        // Act
        cubit.preselectItem(testItem1);
        expect(cubit.state.selectedItem, equals(testItem1));

        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(cubit.state.selectedItem, equals(testUpdatedItem));
        verify(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).called(1);
      },
    );

    group('complex scenarios', () {
      test('should maintain filter after item selection', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).thenAnswer((_) async => testUpdatedItem);

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act
        cubit.filterItems('Pudge');
        cubit.selectItem(testItem1);

        // Assert
        expect(
          cubit.state.items,
          equals(testItems),
        ); // Should reset to all items
        expect(cubit.state.selectedItem, equals(testItem1));
      });

      test('should handle complete workflow', () async {
        // Arrange
        when(mockGetDotaItemsUsecase.get()).thenAnswer((_) async => testItems);
        when(
          mockDotagiftxUnauthApi.getCatalogBySlug('test-item-1'),
        ).thenAnswer((_) async => testUpdatedItem);
        when(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 15.0,
            quantity: 3,
            notes: 'Complete workflow test',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        await Future<void>.delayed(Duration.zero); // Allow init to complete

        // Act - Complete workflow
        cubit.filterItems('Test');
        expect(cubit.state.items.length, equals(2));

        cubit.selectItem(testItem1);
        await Future<void>.delayed(
          Duration.zero,
        ); // Allow catalog call to complete

        cubit.price = '15.0';
        cubit.quantity = '3';
        cubit.notes = 'Complete workflow test';

        await cubit.postItem();

        // Assert
        expect(cubit.state.selectedItem, equals(testUpdatedItem));
        expect(cubit.price, equals('15.0'));
        expect(cubit.quantity, equals('3'));
        expect(cubit.notes, equals('Complete workflow test'));
        expect(showSuccessPostCalled, isTrue);
        verify(
          mockPostListingUsecase.post(
            itemId: 'item-1',
            price: 15.0,
            quantity: 3,
            notes: 'Complete workflow test',
          ),
        ).called(1);
      });
    });
  });
}
