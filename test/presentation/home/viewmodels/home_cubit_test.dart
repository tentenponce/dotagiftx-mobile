import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/debouncer_utils.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_new_buy_orders_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_new_sell_listings_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_trending_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/search_catalog_usecase.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/treasures_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TreasuresCubit>(),
  MockSpec<Logger>(),
  MockSpec<GetTrendingUsecase>(),
  MockSpec<GetNewBuyOrdersUsecase>(),
  MockSpec<GetNewSellListingsUsecase>(),
  MockSpec<SearchCatalogUsecase>(),
  MockSpec<DebouncerUtils>(),
])
void main() {
  group(HomeCubit, () {
    late MockTreasuresCubit mockTreasuresCubit;
    late MockLogger mockLogger;
    late MockGetTrendingUsecase mockGetTrendingUsecase;
    late MockGetNewBuyOrdersUsecase mockGetNewBuyOrdersUsecase;
    late MockGetNewSellListingsUsecase mockGetNewSellListingsUsecase;
    late MockSearchCatalogUsecase mockSearchCatalogUsecase;
    late MockDebouncerUtils mockDebouncerUtils;

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

    const testDotaItem3 = DotaItemModel(
      id: '3',
      name: 'Test Item 3',
      hero: 'Test Hero 3',
      rarity: 'very rare',
      image: 'test_image_3.png',
      lowestAsk: 15.75,
    );

    setUp(() {
      mockTreasuresCubit = MockTreasuresCubit();
      mockLogger = MockLogger();
      mockGetTrendingUsecase = MockGetTrendingUsecase();
      mockGetNewBuyOrdersUsecase = MockGetNewBuyOrdersUsecase();
      mockGetNewSellListingsUsecase = MockGetNewSellListingsUsecase();
      mockSearchCatalogUsecase = MockSearchCatalogUsecase();
      mockDebouncerUtils = MockDebouncerUtils();

      when(mockDebouncerUtils.run(any)).thenAnswer((invocation) async {
        final callback =
            invocation.positionalArguments[0] as Future<void> Function();
        await callback();
      });
    });

    HomeCubit createUnitToTest() {
      return HomeCubit(
        mockTreasuresCubit,
        mockLogger,
        mockGetTrendingUsecase,
        mockGetNewBuyOrdersUsecase,
        mockGetNewSellListingsUsecase,
        mockSearchCatalogUsecase,
        mockDebouncerUtils,
      );
    }

    group('init', () {
      test(
        'should set debouncer milliseconds and call all use cases',
        () async {
          // Arrange
          when(
            mockGetTrendingUsecase.get(),
          ).thenAnswer((_) async => [testDotaItem1]);
          when(
            mockGetNewBuyOrdersUsecase.get(),
          ).thenAnswer((_) async => [testDotaItem2]);
          when(
            mockGetNewSellListingsUsecase.get(),
          ).thenAnswer((_) async => [testDotaItem3]);

          final homeCubit = createUnitToTest();

          // Act
          await homeCubit.init();

          // Assert
          verify(mockDebouncerUtils.milliseconds = 500).called(greaterThan(0));
          verify(mockGetTrendingUsecase.get()).called(greaterThan(0));
          verify(mockGetNewBuyOrdersUsecase.get()).called(greaterThan(0));
          verify(mockGetNewSellListingsUsecase.get()).called(greaterThan(0));
        },
      );
    });

    group('searchCatalog', () {
      test('should clear search results when query is empty', () async {
        // Arrange
        when(
          mockSearchCatalogUsecase.search(query: 'new query', page: 1),
        ).thenAnswer((_) async => ([testDotaItem2], 5));

        final homeCubit = createUnitToTest();

        await homeCubit.searchCatalog(query: 'new query');

        expect(homeCubit.state.searchResults, isNotEmpty);

        // Act
        await homeCubit.searchCatalog(query: '');

        // Assert
        verify(mockDebouncerUtils.cancel()).called(1);
        expect(homeCubit.state.searchResults, isEmpty);
        expect(homeCubit.state.loadingSearchResults, isFalse);
        expect(homeCubit.state.totalSearchResultsCount, equals(0));
      });

      test('should reset pagination state when query changes', () async {
        // Arrange
        when(
          mockSearchCatalogUsecase.search(
            query: anyNamed('query'),
            page: anyNamed('page'),
          ),
        ).thenAnswer((_) async => ([testDotaItem2], 5));

        final homeCubit = createUnitToTest();

        await homeCubit.searchCatalog(query: 'old query');
        await homeCubit.loadMoreSearchResults();

        verify(
          mockSearchCatalogUsecase.search(query: 'old query', page: 2),
        ).called(1);

        // Act
        await homeCubit.searchCatalog(query: 'new query');

        // Assert
        verify(
          mockSearchCatalogUsecase.search(query: 'new query', page: 1),
        ).called(1);
        expect(homeCubit.state.totalSearchResultsCount, equals(5));
      });

      test('should perform search and update state correctly', () async {
        // Arrange
        final searchResults = [testDotaItem1, testDotaItem2];
        when(
          mockSearchCatalogUsecase.search(query: 'test query', page: 1),
        ).thenAnswer((_) async => (searchResults, 25));

        final homeCubit = createUnitToTest();

        // Act
        fakeAsync((async) {
          homeCubit.searchCatalog(query: 'test query');

          async.elapse(const Duration(milliseconds: 10));

          // Assert
          verify(
            mockSearchCatalogUsecase.search(query: 'test query', page: 1),
          ).called(1);
          expect(homeCubit.state.searchResults, equals(searchResults));
          expect(homeCubit.state.totalSearchResultsCount, equals(25));
          expect(homeCubit.state.loadingSearchResults, isFalse);
        });
      });
    });

    group('loadMoreSearchResults', () {
      test('should return early when already loading more results', () async {
        // Arrange
        when(
          mockSearchCatalogUsecase.search(
            query: anyNamed('query'),
            page: anyNamed('page'),
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 10),
            () => ([testDotaItem1], 30),
          ),
        );

        final homeCubit = createUnitToTest();

        fakeAsync((async) {
          homeCubit.searchCatalog(query: 'test query');
          async.elapse(const Duration(milliseconds: 10));

          // Act
          homeCubit.loadMoreSearchResults();
          // try loading here again, and it should not call search because it is still loading
          homeCubit.loadMoreSearchResults();

          // exaggerate the mock elapsed time to make sure the call is finished
          async.elapse(const Duration(milliseconds: 500));

          // Assert
          verify(
            mockSearchCatalogUsecase.search(query: 'test query', page: 2),
          ).called(1);
        });
      });

      test('should return early when current search query is empty', () async {
        // Arrange
        when(
          mockSearchCatalogUsecase.search(
            query: anyNamed('query'),
            page: anyNamed('page'),
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 10),
            () => ([testDotaItem1], 30),
          ),
        );

        final homeCubit = createUnitToTest();

        fakeAsync((async) {
          homeCubit.searchCatalog(query: 'test query');
          async.elapse(const Duration(milliseconds: 10));

          // Act
          homeCubit.searchCatalog(query: ''); // reset query to empty
          homeCubit.loadMoreSearchResults();

          // exaggerate the mock elapsed time to make sure the call is finished
          async.elapse(const Duration(milliseconds: 500));

          // Assert
          verifyNever(mockSearchCatalogUsecase.search(query: '', page: 2));
        });
      });

      test('should return early when no more results available', () async {
        // Arrange
        when(
          mockSearchCatalogUsecase.search(
            query: anyNamed('query'),
            page: anyNamed('page'),
          ),
        ).thenAnswer((_) async => ([testDotaItem1], 1));

        final homeCubit = createUnitToTest();

        await homeCubit.searchCatalog(query: 'test query');

        // Act
        await homeCubit.loadMoreSearchResults();

        // Assert
        verify(
          mockSearchCatalogUsecase.search(query: 'test query', page: 1),
        ).called(1);
        verifyNever(
          mockSearchCatalogUsecase.search(query: 'test query', page: 2),
        );
      });

      test(
        'should load more results and combine with existing results',
        () async {
          // Arrange
          when(
            mockSearchCatalogUsecase.search(query: 'test query', page: 1),
          ).thenAnswer((_) async => ([testDotaItem1], 10));
          when(
            mockSearchCatalogUsecase.search(query: 'test query', page: 2),
          ).thenAnswer((_) async => ([testDotaItem2], 10));

          final homeCubit = createUnitToTest();

          await homeCubit.searchCatalog(query: 'test query');

          // Act
          await homeCubit.loadMoreSearchResults();

          // Assert
          expect(
            homeCubit.state.searchResults,
            equals([testDotaItem1, testDotaItem2]),
          );
        },
      );
    });

    group('error handling', () {
      test('should handle search catalog error gracefully', () async {
        // Arrange
        when(
          mockSearchCatalogUsecase.search(query: 'test query', page: 1),
        ).thenThrow(Exception('Search failed'));
        when(mockDebouncerUtils.run(any)).thenAnswer((invocation) async {
          final callback =
              invocation.positionalArguments[0] as Future<void> Function();
          await callback();
        });

        final homeCubit = createUnitToTest();

        // Act
        await homeCubit.searchCatalog(query: 'test query');

        // Assert
        expect(homeCubit.state.loadingSearchResults, isFalse);
      });
    });

    group('private methods', () {
      test('should load trending items correctly', () async {
        // Arrange
        final trendingItems = [testDotaItem1, testDotaItem2];
        when(
          mockGetTrendingUsecase.get(),
        ).thenAnswer((_) async => trendingItems);
        when(mockGetNewBuyOrdersUsecase.get()).thenAnswer((_) async => []);
        when(mockGetNewSellListingsUsecase.get()).thenAnswer((_) async => []);

        // Act
        createUnitToTest();

        // Assert
        verify(mockGetTrendingUsecase.get()).called(1);
      });

      test('should load new buy orders correctly', () async {
        // Arrange
        final buyOrders = [testDotaItem2];
        when(
          mockGetNewBuyOrdersUsecase.get(),
        ).thenAnswer((_) async => buyOrders);
        when(mockGetTrendingUsecase.get()).thenAnswer((_) async => []);
        when(mockGetNewSellListingsUsecase.get()).thenAnswer((_) async => []);

        // Act
        createUnitToTest();

        // Assert
        verify(mockGetNewBuyOrdersUsecase.get()).called(1);
      });

      test('should load new sell listings correctly', () async {
        // Arrange
        final sellListings = [testDotaItem3];
        when(
          mockGetNewSellListingsUsecase.get(),
        ).thenAnswer((_) async => sellListings);
        when(mockGetTrendingUsecase.get()).thenAnswer((_) async => []);
        when(mockGetNewBuyOrdersUsecase.get()).thenAnswer((_) async => []);

        // Act
        createUnitToTest();

        // Assert
        verify(mockGetNewSellListingsUsecase.get()).called(1);
      });
    });
  });
}
