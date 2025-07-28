import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/debouncer_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
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
  MockSpec<DebouncerUtils>(),
])
void main() {
  group(MyListingsCubit, () {
    late MockLogger mockLogger;
    late MockGetMyListingsUsecase mockGetMyListingsUsecase;
    late MockDebouncerUtils mockDebouncerUtils;

    setUp(() async {
      mockLogger = MockLogger();
      mockGetMyListingsUsecase = MockGetMyListingsUsecase();
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

    test(
      'should return early from loadMoreListings when isLoadingMore is true',
      () async {
        // Arrange
        final unit = createUnitToTest();

        // Act
        unawaited(unit.loadMoreListings());
        unawaited(unit.loadMoreListings());
        unawaited(unit.loadMoreListings());

        // Assert - no calls should be made since we're already loading more
        verify(
          mockGetMyListingsUsecase.get(
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            status: anyNamed('status'),
            searchQuery: anyNamed('searchQuery'),
          ),
        ).called(1);
      },
    );

    test(
      'should return early from loadMoreListings when no more results',
      () async {
        // Arrange
        const testMarketListing1 = MarketListingModel(
          id: '1',
          price: 10.0,
          inventoryStatus: 1,
          user: null,
        );

        when(
          mockGetMyListingsUsecase.get(
            limit: anyNamed('limit'),
            page: anyNamed('page'),
            status: anyNamed('status'),
            searchQuery: anyNamed('searchQuery'),
          ),
        ).thenAnswer((_) async => ([testMarketListing1], 1));

        fakeAsync((async) {
          final unit = createUnitToTest();
          async.elapse(const Duration(milliseconds: 1));

          unit.searchListings('test query');
          async.elapse(const Duration(milliseconds: 500));

          // Act
          unit.loadMoreListings();
          async.elapse(const Duration(milliseconds: 1));

          // Assert
          verify(
            mockGetMyListingsUsecase.get(
              searchQuery: 'test query',
              page: 1,
              limit: 20,
              status: ApiConstants.queryMarketStatusLive,
            ),
          ).called(1);
          verifyNever(
            mockGetMyListingsUsecase.get(
              searchQuery: 'test query',
              page: 2,
              limit: 20,
              status: ApiConstants.queryMarketStatusLive,
            ),
          );
        });
      },
    );
  });
}
