import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/debouncer_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_market_summary_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_my_listings_usecase.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/my_listings_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_listings_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<GetMyListingsUsecase>(),
  MockSpec<GetMarketSummaryUsecase>(),
  MockSpec<DebouncerUtils>(),
])
void main() {
  group(MyListingsCubit, () {
    late MockLogger mockLogger;
    late MockGetMyListingsUsecase mockGetMyListingsUsecase;
    late MockGetMarketSummaryUsecase mockGetMarketSummaryUsecase;
    late MockDebouncerUtils mockDebouncerUtils;

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

    setUp(() async {
      mockLogger = MockLogger();
      mockGetMyListingsUsecase = MockGetMyListingsUsecase();
      mockGetMarketSummaryUsecase = MockGetMarketSummaryUsecase();
      mockDebouncerUtils = MockDebouncerUtils();

      // Setup basic mocks
      when(mockDebouncerUtils.run(any)).thenAnswer((invocation) async {
        final callback =
            invocation.positionalArguments[0] as Future<void> Function();
        await callback();
      });

      when(
        mockGetMyListingsUsecase.get(
          limit: anyNamed('limit'),
          page: anyNamed('page'),
          status: anyNamed('status'),
          searchQuery: anyNamed('searchQuery'),
        ),
      ).thenAnswer((_) async => (const <MarketListingModel>[], 0));
    });

    MyListingsCubit createUnitToTest() {
      return MyListingsCubit(
        mockLogger,
        mockGetMyListingsUsecase,
        mockGetMarketSummaryUsecase,
        mockDebouncerUtils,
      );
    }

    test('should call usecase during initialization', () async {
      // Act
      createUnitToTest();

      // Assert
      verify(
        mockGetMyListingsUsecase.get(
          limit: anyNamed('limit'),
          page: anyNamed('page'),
          status: anyNamed('status'),
          searchQuery: anyNamed('searchQuery'),
        ),
      ).called(1);

      verify(mockGetMarketSummaryUsecase.get()).called(1);
    });

    test('should set debouncer milliseconds during init', () async {
      // Act
      createUnitToTest();

      // Assert
      verify(mockDebouncerUtils.milliseconds = 500).called(1);
    });

    test('should update search query when searchListings is called', () {
      // Arrange
      final unit = createUnitToTest();

      // Act
      unawaited(unit.searchListings('test query'));

      // Assert
      expect(unit.searchQuery, equals('test query'));
    });

    test(
      'should update status when filterBy is called with different status',
      () {
        // Arrange
        final unit = createUnitToTest();

        // Act
        unit.filterBy(ApiConstants.queryMarketStatusReserved);

        // Assert
        expect(
          unit.state.status,
          equals(ApiConstants.queryMarketStatusReserved),
        );
      },
    );

    group('getMarketSummary', () {
      test('should show null market summary when error occurs', () async {
        // Arrange
        when(mockGetMarketSummaryUsecase.get()).thenThrow(Exception('test'));

        // Act
        final unit = createUnitToTest();

        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(unit.state.marketSummary, isNull);
        verify(
          mockLogger.log(
            LogLevel.error,
            'Error getting market summary',
            any,
            any,
          ),
        ).called(1);
      });
    });

    group('refreshListings', () {
      test('should get market summary', () async {
        // Arrange
        final unit = createUnitToTest();

        reset(mockGetMarketSummaryUsecase);

        // Act
        await unit.refreshListings();

        // Assert
        verify(mockGetMarketSummaryUsecase.get()).called(1);
      });

      test('should get listings with page 1 on successful refresh', () async {
        // Arrange
        when(
          mockGetMyListingsUsecase.get(
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            status: anyNamed('status'),
            searchQuery: anyNamed('searchQuery'),
          ),
        ).thenAnswer((_) async => ([testMarketListing1], 30));

        // Act
        final unit = createUnitToTest();

        await Future<void>.delayed(Duration.zero);

        await unit.refreshListings();

        // Assert
        verify(
          mockGetMyListingsUsecase.get(
            limit: 20,
            page: 1,
            status: ApiConstants.queryMarketStatusLive,
            searchQuery: '',
          ),
        ).called(2);
      });
    });

    group('loadMoreListings', () {
      test('should return early when already loading more results', () async {
        // Arrange
        when(
          mockGetMyListingsUsecase.get(
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            status: anyNamed('status'),
            searchQuery: anyNamed('searchQuery'),
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 10),
            () => ([testMarketListing1], 30),
          ),
        );

        fakeAsync((async) {
          final homeCubit = createUnitToTest();
          async.elapse(const Duration(milliseconds: 10));

          homeCubit.searchListings('test query');
          async.elapse(const Duration(milliseconds: 500));

          // Act
          homeCubit.loadMoreListings();
          // try loading here again, and it should not call search because it is still loading
          homeCubit.loadMoreListings();

          // exaggerate the mock elapsed time to make sure the call is finished
          async.elapse(const Duration(milliseconds: 500));

          // Assert
          verify(
            mockGetMyListingsUsecase.get(
              limit: 20,
              page: 2,
              status: ApiConstants.queryMarketStatusLive,
              searchQuery: 'test query',
            ),
          ).called(1);
        });
      });

      test('should return early when current search query is empty', () async {
        // Arrange
        when(
          mockGetMyListingsUsecase.get(
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            status: anyNamed('status'),
            searchQuery: anyNamed('searchQuery'),
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 10),
            () => ([testMarketListing1], 30),
          ),
        );

        final homeCubit = createUnitToTest();

        fakeAsync((async) {
          homeCubit.searchListings('test query');
          async.elapse(const Duration(milliseconds: 10));

          // Act
          homeCubit.searchListings(''); // reset query to empty
          homeCubit.loadMoreListings();

          // exaggerate the mock elapsed time to make sure the call is finished
          async.elapse(const Duration(milliseconds: 500));

          // Assert
          verifyNever(
            mockGetMyListingsUsecase.get(
              limit: 20,
              page: 2,
              status: ApiConstants.queryMarketStatusLive,
              searchQuery: '',
            ),
          );
        });
      });

      test('should return early when no more results available', () async {
        // Arrange
        when(
          mockGetMyListingsUsecase.get(
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            status: anyNamed('status'),
            searchQuery: anyNamed('searchQuery'),
          ),
        ).thenAnswer((_) async => ([testMarketListing1], 1));

        final homeCubit = createUnitToTest();

        await Future<void>.delayed(Duration.zero);

        await homeCubit.searchListings('test query');

        // Act
        await homeCubit.loadMoreListings();

        // Assert
        verify(
          mockGetMyListingsUsecase.get(
            limit: 20,
            page: 1,
            status: ApiConstants.queryMarketStatusLive,
            searchQuery: 'test query',
          ),
        ).called(1);
        verifyNever(
          mockGetMyListingsUsecase.get(
            limit: 20,
            page: 2,
            status: ApiConstants.queryMarketStatusLive,
            searchQuery: 'test query',
          ),
        );
      });

      test(
        'should load more results and combine with existing results',
        () async {
          // Arrange
          when(
            mockGetMyListingsUsecase.get(
              limit: 20,
              page: 1,
              status: ApiConstants.queryMarketStatusLive,
              searchQuery: 'test query',
            ),
          ).thenAnswer((_) async => ([testMarketListing1], 10));

          when(
            mockGetMyListingsUsecase.get(
              limit: 20,
              page: 2,
              status: ApiConstants.queryMarketStatusLive,
              searchQuery: 'test query',
            ),
          ).thenAnswer((_) async => ([testMarketListing2], 10));

          fakeAsync((async) {
            final homeCubit = createUnitToTest();
            async.elapse(const Duration(milliseconds: 10));

            homeCubit.searchListings('test query');
            async.elapse(const Duration(milliseconds: 500));

            // Act
            homeCubit.loadMoreListings();
            async.elapse(const Duration(milliseconds: 500));

            // Assert
            expect(
              homeCubit.state.listings,
              equals([testMarketListing1, testMarketListing2]),
            );
          });
        },
      );
    });
  });
}
