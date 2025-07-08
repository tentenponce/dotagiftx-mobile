import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_item_offers_usecase.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'offers_list_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>(), MockSpec<GetDotaItemOffersUsecase>()])
void main() {
  group(OffersListCubit, () {
    late MockLogger mockLogger;
    late MockGetDotaItemOffersUsecase mockGetOffersUsecase;

    // Test data - Market Stats
    const testMarketStats = MarketStatsModel(
      pending: 0,
      live: 5,
      reserved: 0,
      sold: 10,
      removed: 0,
      cancelled: 0,
      bidLive: 0,
      bidCompleted: 0,
      deliveryNoHit: 0,
      deliveryNameVerified: 0,
      deliverySenderVerified: 0,
      deliveryPrivate: 0,
      deliveryError: 0,
      inventoryNoHit: 0,
      inventoryVerified: 0,
      inventoryPrivate: 0,
      inventoryError: 0,
      resellLive: 0,
      resellReserved: 0,
      resellSold: 0,
      resellRemoved: 0,
      resellCancelled: 0,
    );

    // Test data - Users
    const testUser1 = UserModel(
      id: 'user1',
      steamId: 'steam1',
      name: 'Test User 1',
      url: 'https://example.com/user1',
      avatar: 'https://example.com/avatar1.png',
      status: 1,
      notes: '',
      donation: 0,
      createdAt: '2023-01-01T00:00:00Z',
      updatedAt: '2023-01-01T00:00:00Z',
      marketStats: testMarketStats,
      rankScore: 100,
      subscription: 1,
      subscriptionType: 'premium',
      hammer: false,
    );

    const testUser2 = UserModel(
      id: 'user2',
      steamId: 'steam2',
      name: 'Test User 2',
      url: 'https://example.com/user2',
      avatar: 'https://example.com/avatar2.png',
      status: 1,
      notes: '',
      donation: 0,
      createdAt: '2023-01-02T00:00:00Z',
      updatedAt: '2023-01-02T00:00:00Z',
      marketStats: testMarketStats,
      rankScore: 50,
      subscription: 0,
      subscriptionType: 'basic',
      hammer: false,
    );

    // Test data - Offers
    const testOffer1 = MarketListingModel(
      id: 'offer1',
      userId: 'user1',
      itemId: 'item1',
      type: 1,
      status: 1,
      price: 100.0,
      currency: 'USD',
      partnerSteamId: 'partner1',
      notes: '',
      createdAt: '2023-01-01T00:00:00Z',
      updatedAt: '2023-01-01T00:00:00Z',
      inventoryStatus: 1,
      deliveryStatus: 1,
      user: testUser1,
      item: DotaItemModel(id: 'item1', name: 'Test Item 1'),
      inventory: null,
      sellerSteamId: 'seller1',
      userRankScore: 100,
    );

    const testOffer2 = MarketListingModel(
      id: 'offer2',
      userId: 'user2',
      itemId: 'item2',
      type: 1,
      status: 1,
      price: 200.0,
      currency: 'USD',
      partnerSteamId: 'partner2',
      notes: '',
      createdAt: '2023-01-02T00:00:00Z',
      updatedAt: '2023-01-02T00:00:00Z',
      inventoryStatus: 1,
      deliveryStatus: 1,
      user: testUser2,
      item: DotaItemModel(id: 'item2', name: 'Test Item 2'),
      inventory: null,
      sellerSteamId: 'seller2',
      userRankScore: 50,
    );

    const testOffer3 = MarketListingModel(
      id: 'offer3',
      userId: 'user1',
      itemId: 'item3',
      type: 1,
      status: 1,
      price: 150.0,
      currency: 'USD',
      partnerSteamId: 'partner3',
      notes: '',
      createdAt: '2023-01-03T00:00:00Z',
      updatedAt: '2023-01-03T00:00:00Z',
      inventoryStatus: 1,
      deliveryStatus: 1,
      user: testUser1,
      item: DotaItemModel(id: 'item3', name: 'Test Item 3'),
      inventory: null,
      sellerSteamId: 'seller3',
      userRankScore: 100,
    );

    const testItemId = 'test-item-id';

    setUp(() {
      mockLogger = MockLogger();
      mockGetOffersUsecase = MockGetDotaItemOffersUsecase();
    });

    OffersListCubit createUnitToTest() {
      return OffersListCubit(mockLogger, mockGetOffersUsecase);
    }

    group('getNewOffers', () {
      test('should load offers successfully', () async {
        // Arrange
        final offers = [testOffer1, testOffer2];
        const totalCount = 10;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (offers, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              limit: anyNamed('limit'),
              page: 1,
              sort: ApiConstants.querySortLowest,
            ),
          ).called(1);
          expect(cubit.state.offers, equals(offers));
          expect(cubit.state.totalOffersCount, equals(totalCount));
          expect(cubit.state.isLoading, isFalse);
        });
      });

      test('should not load if already loading', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.setItemId(testItemId);

        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 100),
            () => ([testOffer1], 1),
          ),
        );

        fakeAsync((async) {
          // Act - Call getNewOffers twice quickly
          unawaited(cubit.getNewOffers());
          unawaited(cubit.getNewOffers());

          async.elapse(const Duration(milliseconds: 200));

          // Assert - Should only be called once
          verify(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortLowest,
            ),
          ).called(1);
        });
      });
    });

    group('loadMoreOffers', () {
      test('should load more offers successfully', () async {
        // Arrange - Setup initial state
        final initialOffers = [testOffer1];
        const totalCount = 10;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (initialOffers, totalCount));

        final moreOffers = [testOffer2, testOffer3];
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 2,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (moreOffers, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Act
          cubit.loadMoreOffers();

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 2,
              sort: ApiConstants.querySortLowest,
            ),
          ).called(1);
          expect(cubit.state.offers.length, equals(3));
          expect(cubit.state.offers, contains(testOffer1));
          expect(cubit.state.offers, contains(testOffer2));
          expect(cubit.state.offers, contains(testOffer3));
          expect(cubit.state.isLoadingMore, isFalse);
        });
      });

      test('should not load more if already loading more', () async {
        // Arrange - Setup initial state
        final initialOffers = [testOffer1];
        const totalCount = 10;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (initialOffers, totalCount));

        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 2,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 100),
            () => ([testOffer2], totalCount),
          ),
        );

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Act - Call loadMoreOffers twice quickly
          unawaited(cubit.loadMoreOffers());
          unawaited(cubit.loadMoreOffers());

          async.elapse(const Duration(milliseconds: 200));

          // Assert - Should only be called once
          verify(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 2,
              sort: ApiConstants.querySortLowest,
            ),
          ).called(1);
        });
      });

      test('should not load more if no more offers available', () async {
        // Arrange - Setup initial state with all offers loaded
        final allOffers = [testOffer1, testOffer2];
        const totalCount = 2;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (allOffers, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Act
          cubit.loadMoreOffers();

          async.elapse(Duration.zero);

          // Assert - Should not call for page 2
          verifyNever(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 2,
              sort: ApiConstants.querySortLowest,
            ),
          );
          expect(cubit.state.offers.length, equals(2));
        });
      });
    });

    group('sortBy', () {
      test('should update sort and reload offers', () async {
        // Arrange
        final offers = [testOffer1, testOffer2];
        const totalCount = 5;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            limit: anyNamed('limit'),
            page: 1,
            sort: ApiConstants.querySortRecent,
          ),
        ).thenAnswer((_) async => (offers, totalCount));

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
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortRecent,
            ),
          ).called(1);
        });
      });

      test('should not reload offers if sort is the same', () async {
        // Arrange
        final offers = [testOffer1, testOffer2];
        const totalCount = 5;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (offers, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Verify initial call was made
          verify(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortLowest,
            ),
          ).called(1);

          // Act - Call sortBy with the same sort (default is querySortLowest)
          cubit.sortBy(ApiConstants.querySortLowest);

          async.elapse(Duration.zero);

          // Assert - Should not make additional calls since sort is the same
          verifyNever(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortLowest,
            ),
          ); // Should not make additional calls since sort is the same
          expect(cubit.state.sort, equals(ApiConstants.querySortLowest));
          expect(cubit.state.offers, equals(offers));
        });
      });
    });

    group('setItemId', () {
      test('should set item ID and load offers', () async {
        // Arrange
        final offers = [testOffer1];
        const totalCount = 3;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (offers, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();

          // Act
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Assert
          verify(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 1,
              sort: ApiConstants.querySortLowest,
            ),
          ).called(1);
          expect(cubit.state.offers, equals(offers));
          expect(cubit.state.totalOffersCount, equals(totalCount));
        });
      });
    });

    group('complex scenarios', () {
      test('should maintain sort when loading more offers', () async {
        // Arrange
        final initialOffers = [testOffer1];
        const totalCount = 10;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortRecent,
          ),
        ).thenAnswer((_) async => (initialOffers, totalCount));

        final moreOffers = [testOffer2];
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            page: 2,
            sort: ApiConstants.querySortRecent,
          ),
        ).thenAnswer((_) async => (moreOffers, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          cubit.sortBy(ApiConstants.querySortRecent);

          async.elapse(Duration.zero);

          // Act
          cubit.loadMoreOffers();

          async.elapse(Duration.zero);

          // Assert - Verify the exact call with all parameters
          verify(
            mockGetOffersUsecase.get(
              itemId: testItemId,
              page: 2,
              sort: ApiConstants.querySortRecent,
            ),
          ).called(1);
        });
      });

      test('should handle empty offers list', () async {
        // Arrange
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (<MarketListingModel>[], 0));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.offers, isEmpty);
          expect(cubit.state.totalOffersCount, equals(0));
        });
      });

      test('should reset page when sorting changes', () async {
        // Arrange
        final initialOffers = [testOffer1];
        const totalCount = 10;
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (initialOffers, totalCount));

        final moreOffers = [testOffer2];
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            page: 2,
            sort: ApiConstants.querySortLowest,
          ),
        ).thenAnswer((_) async => (moreOffers, totalCount));

        final sortedOffers = [testOffer3];
        when(
          mockGetOffersUsecase.get(
            itemId: testItemId,
            page: 1,
            sort: ApiConstants.querySortRecent,
          ),
        ).thenAnswer((_) async => (sortedOffers, totalCount));

        fakeAsync((async) {
          final cubit = createUnitToTest();
          cubit.setItemId(testItemId);

          async.elapse(Duration.zero);

          // Load more to go to page 2
          cubit.loadMoreOffers();

          async.elapse(Duration.zero);

          // Act - Change sort (should reset to page 1)
          cubit.sortBy(ApiConstants.querySortRecent);

          async.elapse(Duration.zero);

          // Assert
          expect(cubit.state.offers, equals(sortedOffers));
          verify(
            mockGetOffersUsecase.get(
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
