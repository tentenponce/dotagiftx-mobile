import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_item_orders_usecase.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/buy_orders_list_state.dart';
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
    late BuyOrdersListCubit cubit;

    const testItemId = 'test-item-id';
    const testEmptyItemId = '';
    const String? testNullItemId = null;

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
      cubit = BuyOrdersListCubit(mockLogger, mockGetOrdersUsecase);
    });

    tearDown(() {
      cubit.close();
    });

    group('constructor', () {
      test('should initialize with correct initial state', () {
        // Assert
        expect(cubit.state, const BuyOrdersListState());
        expect(cubit.logger, mockLogger);
        verify(mockLogger.logFor(cubit)).called(1);
      });
    });

    group('logger', () {
      test('should return injected logger', () {
        // Assert
        expect(cubit.logger, equals(mockLogger));
      });
    });

    group('init', () {
      test('should complete without error', () async {
        // Act & Assert
        await expectLater(cubit.init(), completes);
      });
    });

    group('setItemId', () {
      test('should set item ID and fetch buy orders', () async {
        // Arrange
        final buyOrders = [testBuyOrder1, testBuyOrder2];
        const totalCount = 5;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (buyOrders, totalCount));

        fakeAsync((async) {
          // Act
          cubit.setItemId(testItemId);

          // Let the async operation complete
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

          expect(cubit.state.buyOrders, buyOrders);
          expect(cubit.state.totalBuyOrdersCount, totalCount);
          expect(cubit.state.isLoading, false);
        });
      });

      test('should not fetch buy orders if item ID is empty', () async {
        // Act
        cubit.setItemId(testEmptyItemId);

        // Assert
        verifyNever(
          mockGetOrdersUsecase.get(
            itemId: anyNamed('itemId'),
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            sort: anyNamed('sort'),
          ),
        );
        verify(
          mockLogger.log(
            LogLevel.error,
            'setItemId > Item ID is null or empty',
          ),
        ).called(1);
      });
    });

    group('getNewBuyOrders', () {
      test('should fetch buy orders successfully', () async {
        // Arrange
        final buyOrders = [testBuyOrder1, testBuyOrder2];
        const totalCount = 5;
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (buyOrders, totalCount));

        fakeAsync((async) {
          // Set item ID first
          cubit.setItemId(testItemId);
          async.elapse(Duration.zero);

          // Act
          cubit.getNewBuyOrders();
          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.buyOrders, buyOrders);
          expect(cubit.state.totalBuyOrdersCount, totalCount);
          expect(cubit.state.currentPage, 1);
          expect(cubit.state.isLoading, false);
        });
      });

      test('should not fetch if already loading', () async {
        // Arrange
        cubit.setItemId(testItemId);
        cubit.emit(cubit.state.copyWith(isLoading: true));

        // Act
        await cubit.getNewBuyOrders();

        // Assert
        verifyNever(
          mockGetOrdersUsecase.get(
            itemId: anyNamed('itemId'),
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            sort: anyNamed('sort'),
          ),
        );
      });

      test('should handle errors gracefully', () async {
        // Arrange
        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenThrow(Exception('API Error'));

        fakeAsync((async) {
          // Set item ID first
          cubit.setItemId(testItemId);
          async.elapse(Duration.zero);

          // Act
          cubit.getNewBuyOrders();
          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.isLoading, false);
          expect(cubit.state.buyOrders, isEmpty);
        });
      });
    });

    group('loadMoreBuyOrders', () {
      test('should load more buy orders successfully', () async {
        // Arrange
        final initialBuyOrders = [testBuyOrder1];
        final additionalBuyOrders = [testBuyOrder2];
        const totalCount = 10;

        // Set up initial state
        cubit.emit(
          cubit.state.copyWith(
            buyOrders: initialBuyOrders,
            totalBuyOrdersCount: totalCount,
            currentPage: 1,
          ),
        );

        when(
          mockGetOrdersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 2,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (additionalBuyOrders, totalCount));

        fakeAsync((async) {
          // Set item ID
          cubit.setItemId(testItemId);
          async.elapse(Duration.zero);

          // Act
          cubit.loadMoreBuyOrders();
          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.buyOrders, [
            ...initialBuyOrders,
            ...additionalBuyOrders,
          ]);
          expect(cubit.state.currentPage, 2);
          expect(cubit.state.isLoadingMore, false);
        });
      });

      test('should not load more if already loading more', () async {
        // Arrange
        cubit.emit(cubit.state.copyWith(isLoadingMore: true));

        // Act
        await cubit.loadMoreBuyOrders();

        // Assert
        verifyNever(
          mockGetOrdersUsecase.get(
            itemId: anyNamed('itemId'),
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            sort: anyNamed('sort'),
          ),
        );
      });

      test('should not load more if all buy orders are loaded', () async {
        // Arrange
        final buyOrders = [testBuyOrder1, testBuyOrder2];
        cubit.emit(
          cubit.state.copyWith(
            buyOrders: buyOrders,
            totalBuyOrdersCount: buyOrders.length,
          ),
        );

        // Act
        await cubit.loadMoreBuyOrders();

        // Assert
        verifyNever(
          mockGetOrdersUsecase.get(
            itemId: anyNamed('itemId'),
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            sort: anyNamed('sort'),
          ),
        );
      });
    });

    group('sortBy', () {
      test('should sort buy orders by different sort option', () async {
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
          final cubit = BuyOrdersListCubit(mockLogger, mockGetOrdersUsecase);
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Act
          cubit.sortBy(ApiConstants.querySortRecent);
          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.sort, ApiConstants.querySortRecent);
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              limit: anyNamed('limit'),
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
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortHighest,
          ),
        ).thenAnswer((_) async => (buyOrders, totalCount));

        fakeAsync((async) {
          final cubit = BuyOrdersListCubit(mockLogger, mockGetOrdersUsecase);
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Verify initial call was made
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              limit: anyNamed('limit'),
              page: 1,
              sort: ApiConstants.querySortHighest,
            ),
          ).called(1);

          // Act - try to sort by the same sort (should not make another call)
          cubit.sortBy(ApiConstants.querySortHighest);
          async.elapse(Duration.zero);

          // Assert - should still be only 1 call (no additional calls)
          verify(
            mockGetOrdersUsecase.get(
              itemId: testItemId,
              limit: anyNamed('limit'),
              page: 1,
              sort: ApiConstants.querySortHighest,
            ),
          ).called(1);

          // State should remain unchanged
          expect(cubit.state.sort, ApiConstants.querySortHighest);
          expect(cubit.state.buyOrders, buyOrders);
        });
      });
    });
  });
}
