import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/dota_item_detail_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/buy_orders_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dota_item_detail_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<OffersListCubit>(),
  MockSpec<BuyOrdersListCubit>(),
])
void main() {
  group(DotaItemDetailCubit, () {
    late MockLogger mockLogger;
    late MockOffersListCubit mockOffersListCubit;
    late MockBuyOrdersListCubit mockBuyOrdersListCubit;

    const testItemId = 'test-item-id';
    const testEmptyItemId = '';
    const String? testNullItemId = null;

    setUp(() {
      mockLogger = MockLogger();
      mockOffersListCubit = MockOffersListCubit();
      mockBuyOrdersListCubit = MockBuyOrdersListCubit();
    });

    DotaItemDetailCubit createUnitToTest() {
      return DotaItemDetailCubit(
        mockOffersListCubit,
        mockBuyOrdersListCubit,
        mockLogger,
      );
    }

    group('logger', () {
      test('should return the injected logger', () {
        // Arrange
        final cubit = createUnitToTest();

        // Act & Assert
        expect(cubit.logger, equals(mockLogger));
      });
    });

    group('onTabChanged', () {
      test('should change tab to offers', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.onTabChanged(MarketTab.offers);

        // Assert
        expect(cubit.state.tab, equals(MarketTab.offers));
      });

      test('should change tab to buy orders', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.onTabChanged(MarketTab.buyOrders);

        // Assert
        expect(cubit.state.tab, equals(MarketTab.buyOrders));
      });
    });

    group('setItemId', () {
      test('should set item ID and call offers list cubit', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.setItemId(testItemId);

        // Assert
        verify(mockOffersListCubit.setItemId(testItemId)).called(1);
      });

      test('should handle empty item ID', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.setItemId(testEmptyItemId);

        // Assert
        verify(
          mockLogger.log(
            LogLevel.error,
            'setItemId > Item ID is null or empty',
          ),
        ).called(1);
        verifyNever(mockOffersListCubit.setItemId(any));
      });

      test('should handle null item ID', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.setItemId(testNullItemId);

        // Assert
        verify(
          mockLogger.log(
            LogLevel.error,
            'setItemId > Item ID is null or empty',
          ),
        ).called(1);
        verifyNever(mockOffersListCubit.setItemId(any));
      });

      test('should not call offers list cubit for invalid item ID', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.setItemId('   '); // whitespace only

        // Assert
        verify(
          mockLogger.log(
            LogLevel.error,
            'setItemId > Item ID is null or empty',
          ),
        ).called(1);
        verifyNever(mockOffersListCubit.setItemId(any));
      });
    });

    group('onSwipeToRefresh', () {
      test(
        'should call offers list cubit getNewOffers when item ID is valid',
        () async {
          // Arrange
          final cubit = createUnitToTest();
          when(mockOffersListCubit.getNewOffers()).thenAnswer((_) async {
            return;
          });

          // Setup item ID first
          cubit.setItemId(testItemId);

          // Act
          cubit.onSwipeToRefresh();

          // Assert
          verify(mockOffersListCubit.getNewOffers()).called(1);
        },
      );

      test('should log error when item ID is not set', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        cubit.onSwipeToRefresh();

        // Assert
        verify(
          mockLogger.log(
            LogLevel.error,
            'onSwipeToRefresh > Item ID is null or empty',
          ),
        ).called(1);
        verifyNever(mockOffersListCubit.getNewOffers());
      });

      test('should log error when item ID is empty', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.setItemId(testEmptyItemId);

        // Clear any previous interactions
        clearInteractions(mockLogger);

        // Act
        cubit.onSwipeToRefresh();

        // Assert - Should only call logger once in onSwipeToRefresh since _itemId is empty
        verify(
          mockLogger.log(
            LogLevel.error,
            'onSwipeToRefresh > Item ID is null or empty',
          ),
        ).called(1);
        verifyNever(mockOffersListCubit.getNewOffers());
      });
    });
  });
}
