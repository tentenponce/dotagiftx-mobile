import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_my_listings_usecase.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/my_listings_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/my_listings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_listings_cubit_test.mocks.dart';

@GenerateMocks([Logger, GetMyListingsUsecase])
void main() {
  late MyListingsCubit cubit;
  late MockLogger mockLogger;
  late MockGetMyActiveListingsUsecase mockGetMyActiveListingsUsecase;

  setUp(() {
    mockLogger = MockLogger();
    mockGetMyActiveListingsUsecase = MockGetMyActiveListingsUsecase();
    cubit = MyListingsCubit(mockLogger, mockGetMyActiveListingsUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  group('MyListingsCubit', () {
    test('initial state is correct', () {
      expect(cubit.state, equals(const MyListingsState()));
    });

    test('loadListings updates state correctly on success', () async {
      // Arrange
      const mockListings = <MarketListingModel>[];
      const mockTotalCount = 0;
      when(
        mockGetMyActiveListingsUsecase.get(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => (mockListings, mockTotalCount));

      // Act
      await cubit.getMyListings();

      // Assert
      expect(cubit.state.listings, equals(mockListings));
      expect(cubit.state.totalListingsCount, equals(mockTotalCount));
      expect(cubit.state.loadingListings, isFalse);
    });

    test('loadListings sets loading state correctly', () async {
      // Arrange
      when(
        mockGetMyActiveListingsUsecase.get(
          limit: any(named: 'limit'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => (const <MarketListingModel>[], 0));

      // Act
      final future = cubit.getMyListings();

      // Assert loading state
      expect(cubit.state.loadingListings, isTrue);

      await future;
      expect(cubit.state.loadingListings, isFalse);
    });
  });
}
