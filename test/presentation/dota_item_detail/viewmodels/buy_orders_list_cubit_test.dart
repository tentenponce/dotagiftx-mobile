import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_item_orders_usecase.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/buy_orders_list_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'buy_orders_list_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>(), MockSpec<GetDotaItemOrdersUsecase>()])
void main() {
  group(BuyOrdersListCubit, () {
    late MockLogger mockLogger;
    late MockGetDotaItemOrdersUsecase mockGetOrdersUsecase;

    const testItemId = 'test-item-id';

    // Test data - Users
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

    const testBuyOrder3 = MarketListingModel(
      id: 'order3',
      price: 150.0,
      createdAt: '2023-01-03T00:00:00Z',
      inventoryStatus: 1,
      user: testUser1,
      resell: false,
    );

    setUp(() {
      mockLogger = MockLogger();
      mockGetOrdersUsecase = MockGetDotaItemOrdersUsecase();
    });

    BuyOrdersListCubit createUnitToTest() {
      return BuyOrdersListCubit(mockLogger, mockGetOrdersUsecase);
    }

    group('getNewBuyOrders', () {
      test('should load buy orders successfully', () async {
        // Arrange
        final buyOrders = [testBuyOrder1, testBuyOrder2];
        const totalCount = 10;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (buyOrders, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              limit: anyNamed('limit'),
              page: 1,
              sort: ApiConstants.querySortHighest,
            ),
          ).called(1);
          expect(cubit.state.buyOrders, equals(buyOrders));
          expect(cubit.state.totalBuyOrdersCount, equals(totalCount));
          expect(cubit.state.isLoading, isFalse);
        });
      });

      test('should not load if already loading', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.setItemId(testItemId);

        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 100),
            () => ([testBuyOrder1], 1),
          ),
        );

        fakeAsync((async) {
          // Act - Call getNewBuyOrders twice quickly
          unawaited(cubit.getNewBuyOrders());
          unawaited(cubit.getNewBuyOrders());

          async.elapse(const Duration(milliseconds: 200));

          // Assert - Should only be called once
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortHighest,
            ),
          ).called(1);
        });
      });
    });

    group('loadMoreBuyOrders', () {
      test('should load more buy orders successfully', () async {
        // Arrange - Setup initial state
        final initialBuyOrders = [testBuyOrder1];
        const totalCount = 10;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (initialBuyOrders, totalCount));

        final moreBuyOrders = [testBuyOrder2, testBuyOrder3];
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 2,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (moreBuyOrders, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Act
          cubit.loadMoreBuyOrders();

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 2,
              sort: ApiConstants.querySortHighest,
            ),
          ).called(1);
          expect(cubit.state.buyOrders.length, equals(3));
          expect(cubit.state.buyOrders, contains(testBuyOrder1));
          expect(cubit.state.buyOrders, contains(testBuyOrder2));
          expect(cubit.state.buyOrders, contains(testBuyOrder3));
          expect(cubit.state.isLoadingMore, isFalse);
        });
      });

      test('should not load more if already loading more', () async {
        // Arrange - Setup initial state
        final initialBuyOrders = [testBuyOrder1];
        const totalCount = 10;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (initialBuyOrders, totalCount));

        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 2,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 100),
            () => ([testBuyOrder2], totalCount),
          ),
        );

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Act - Call loadMoreBuyOrders twice quickly
          unawaited(cubit.loadMoreBuyOrders());
          unawaited(cubit.loadMoreBuyOrders());

          async.elapse(const Duration(milliseconds: 200));

          // Assert - Should only be called once
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 2,
              sort: ApiConstants.querySortHighest,
            ),
          ).called(1);
        });
      });

      test('should not load more if no more buy orders available', () async {
        // Arrange - Setup initial state with all buy orders loaded
        final allBuyOrders = [testBuyOrder1, testBuyOrder2];
        const totalCount = 2;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (allBuyOrders, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Act
          cubit.loadMoreBuyOrders();

          async.elapse(Duration.zero);

          // Assert - Should not call for page 2
          verifyNever(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 2,
              sort: ApiConstants.querySortHighest,
            ),
          );
          expect(cubit.state.buyOrders.length, equals(2));
        });
      });
    });

    group('sortBy', () {
      test('should update sort and reload buy orders', () async {
        // Arrange
        final buyOrders = [testBuyOrder1, testBuyOrder2];
        const totalCount = 5;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortRecent,
          ),
        ).thenAnswer((_) async => (buyOrders, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Act
          cubit.sortBy(ApiConstants.querySortRecent);

          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.sort, equals(ApiConstants.querySortRecent));
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortRecent,
            ),
          ).called(1);
        });
      });

      test('should not reload buy orders if sort is the same', () async {
        // Arrange
        final buyOrders = [testBuyOrder1, testBuyOrder2];
        const totalCount = 5;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (buyOrders, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Verify initial call was made
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortHighest,
            ),
          ).called(1);

          // Act - Call sortBy with the same sort (default is querySortHighest)
          cubit.sortBy(ApiConstants.querySortHighest);

          async.elapse(Duration.zero);

          // Assert - Should not make additional calls since sort is the same
          verifyNever(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortHighest,
            ),
          ); // Should not make additional calls since sort is the same
          expect(cubit.state.sort, equals(ApiConstants.querySortHighest));
          expect(cubit.state.buyOrders, equals(buyOrders));
        });
      });
    });

    group('setItemId', () {
      test('should set item ID and load buy orders', () async {
        // Arrange
        final buyOrders = [testBuyOrder1];
        const totalCount = 3;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (buyOrders, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();

          // Act
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortHighest,
            ),
          ).called(1);
          expect(cubit.state.buyOrders, equals(buyOrders));
          expect(cubit.state.totalBuyOrdersCount, equals(totalCount));
        });
      });
    });

    group('complex scenarios', () {
      test('should maintain sort when loading more buy orders', () async {
        // Arrange
        final initialBuyOrders = [testBuyOrder1];
        const totalCount = 10;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortRecent,
          ),
        ).thenAnswer((_) async => (initialBuyOrders, totalCount));

        final moreBuyOrders = [testBuyOrder2];
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            page: 2,
            sort: ApiConstants.querySortRecent,
          ),
        ).thenAnswer((_) async => (moreBuyOrders, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          cubit.sortBy(ApiConstants.querySortRecent);

          async.elapse(Duration.zero);

          // Act
          cubit.loadMoreBuyOrders();

          async.elapse(Duration.zero);

          // Assert - Verify the exact call with all parameters
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 2,
              sort: ApiConstants.querySortRecent,
            ),
          ).called(1);
        });
      });

      test('should handle empty buy orders list', () async {
        // Arrange
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (<MarketListingModel>[], 0));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.buyOrders, isEmpty);
          expect(cubit.state.totalBuyOrdersCount, equals(0));
        });
      });

      test('should reset page when sorting changes', () async {
        // Arrange
        final initialBuyOrders = [testBuyOrder1];
        const totalCount = 10;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (initialBuyOrders, totalCount));

        final moreBuyOrders = [testBuyOrder2];
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            page: 2,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (moreBuyOrders, totalCount));

        final sortedBuyOrders = [testBuyOrder3];
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortRecent,
          ),
        ).thenAnswer((_) async => (sortedBuyOrders, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Load more to go to page 2
          cubit.loadMoreBuyOrders();

          async.elapse(Duration.zero);

          // Act - Change sort (should reset to page 1)
          cubit.sortBy(ApiConstants.querySortRecent);

          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.buyOrders, equals(sortedBuyOrders));
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortRecent,
            ),
          ).called(1);
        });
      });
    });
  });
}
