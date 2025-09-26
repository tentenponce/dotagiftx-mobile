import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/place_buy_order_usecase.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/viewmodels/place_buy_order_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'place_buy_order_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>(), MockSpec<PlaceBuyOrderUsecase>()])
void main() {
  group(PlaceBuyOrderCubit, () {
    late MockLogger mockLogger;
    late MockPlaceBuyOrderUsecase mockPlaceBuyOrderUsecase;
    late bool showSuccessOrderCalled;

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

    const testItemWithNullFields = DotaItemModel(
      id: 'item-4',
      name: null,
      hero: null,
      slug: 'item-with-nulls',
    );

    const testApiErrorMessage = 'API Error: Test error message';

    setUp(() {
      mockLogger = MockLogger();
      mockPlaceBuyOrderUsecase = MockPlaceBuyOrderUsecase();
      showSuccessOrderCalled = false;
    });

    PlaceBuyOrderCubit createUnitToTest() {
      final cubit = PlaceBuyOrderCubit(mockLogger, mockPlaceBuyOrderUsecase);

      // Set up callback functions
      cubit.showSuccessOrder = () {
        showSuccessOrderCalled = true;
      };

      return cubit;
    }

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

    group('placeBuyOrder', () {
      test('should place buy order successfully', () async {
        // Arrange
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: 'test notes',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '10.5';
        cubit.notes = 'test notes';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: 'test notes',
          ),
        ).called(1);
      });

      test('should place buy order successfully with empty notes', () async {
        // Arrange
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 15.99,
            notes: '',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '15.99';
        cubit.notes = '';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 15.99,
            notes: '',
          ),
        ).called(1);
      });

      test('should handle null selected item with error handler', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.selectedItem = null;
        cubit.price = '10.5';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isFalse);
        verifyNever(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            notes: anyNamed('notes'),
          ),
        );
        // Verify error handler was called
        verify(mockLogger.log(LogLevel.error, any, any, any)).called(1);
      });

      test('should show price error when price is 0', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '0';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPriceErrorRequired, isTrue);
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isFalse);
        verifyNever(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            notes: anyNamed('notes'),
          ),
        );
      });

      test('should show price error when price is negative', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '-5';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPriceErrorRequired, isTrue);
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isFalse);
        verifyNever(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            notes: anyNamed('notes'),
          ),
        );
      });

      test('should handle invalid price format', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = 'invalid';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPriceErrorRequired, isTrue);
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isFalse);
        verifyNever(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            notes: anyNamed('notes'),
          ),
        );
      });

      test('should handle empty price', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPriceErrorRequired, isTrue);
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isFalse);
        verifyNever(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: anyNamed('itemId'),
            price: anyNamed('price'),
            notes: anyNamed('notes'),
          ),
        );
      });

      test('should set loading state during place buy order', () async {
        // Arrange
        final completer = Completer<void>();
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: '',
          ),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '10.5';

        // Act
        final orderFuture = cubit.placeBuyOrder();

        // Assert loading state
        expect(cubit.state.isPlaceBuyOrderLoading, isTrue);

        // Complete the order
        completer.complete();
        await orderFuture;

        // Assert final state
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
      });

      test('should handle API exception', () async {
        // Arrange
        final exception = Exception('API error: $testApiErrorMessage');

        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: '',
          ),
        ).thenThrow(exception);

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '10.5';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isFalse);
        verify(mockLogger.log(LogLevel.error, any, any, any)).called(1);
      });

      test('should handle generic exception', () async {
        // Arrange
        final exception = Exception('Generic error');

        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: '',
          ),
        ).thenThrow(exception);

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '10.5';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isFalse);
        verify(mockLogger.log(LogLevel.error, any, any, any)).called(1);
      });

      test('should handle item with null fields', () async {
        // Arrange
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-4',
            price: 25.0,
            notes: 'test with null fields',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItemWithNullFields;
        cubit.price = '25.0';
        cubit.notes = 'test with null fields';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-4',
            price: 25.0,
            notes: 'test with null fields',
          ),
        ).called(1);
      });

      test('should handle very small price values', () async {
        // Arrange
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 0.01,
            notes: '',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '0.01';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 0.01,
            notes: '',
          ),
        ).called(1);
      });

      test('should handle very large price values', () async {
        // Arrange
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 999999.99,
            notes: '',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '999999.99';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 999999.99,
            notes: '',
          ),
        ).called(1);
      });

      test('should handle very long notes', () async {
        // Arrange
        final longNotes = 'A' * 1000; // Very long string
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: longNotes,
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '10.5';
        cubit.notes = longNotes;

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: longNotes,
          ),
        ).called(1);
      });

      test('should handle special characters in notes', () async {
        // Arrange
        const specialNotes = 'Notes with émojis 🎮 and spëcial çhars!';
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: specialNotes,
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '10.5';
        cubit.notes = specialNotes;

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: specialNotes,
          ),
        ).called(1);
      });
    });

    group('complex scenarios', () {
      test(
        'should handle multiple property changes before placing order',
        () async {
          // Arrange
          when(
            mockPlaceBuyOrderUsecase.placeBuyOrder(
              itemId: 'item-2',
              price: 50.75,
              notes: 'final notes',
            ),
          ).thenAnswer((_) async => {});

          final cubit = createUnitToTest();

          // Act - Multiple property changes
          cubit.selectedItem = testItem1;
          cubit.price = '10.0';
          cubit.notes = 'initial notes';

          cubit.selectedItem = testItem2; // Change item
          cubit.price = '50.75'; // Change price
          cubit.notes = 'final notes'; // Change notes

          await cubit.placeBuyOrder();

          // Assert
          expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
          expect(showSuccessOrderCalled, isTrue);
          verify(
            mockPlaceBuyOrderUsecase.placeBuyOrder(
              itemId: 'item-2', // Should use final item
              price: 50.75, // Should use final price
              notes: 'final notes', // Should use final notes
            ),
          ).called(1);
        },
      );

      test('should handle price error state changes', () async {
        // Arrange
        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;

        // Act & Assert - Test price error state changes
        cubit.price = ''; // Should set error
        expect(cubit.state.isPriceErrorRequired, isTrue);

        cubit.price = '10.5'; // Should clear error
        expect(cubit.state.isPriceErrorRequired, isFalse);

        cubit.price = ''; // Should set error again
        expect(cubit.state.isPriceErrorRequired, isTrue);
      });

      test('should handle complete workflow', () async {
        // Arrange
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 25.50,
            notes: 'Complete workflow test',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();

        // Act - Complete workflow
        cubit.selectedItem = testItem1;
        cubit.price = '25.50';
        cubit.notes = 'Complete workflow test';

        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.selectedItem, equals(testItem1));
        expect(cubit.price, equals('25.50'));
        expect(cubit.notes, equals('Complete workflow test'));
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(cubit.state.isPriceErrorRequired, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 25.50,
            notes: 'Complete workflow test',
          ),
        ).called(1);
      });
    });

    group('edge cases and boundary conditions', () {
      test('should handle decimal price precision', () async {
        // Arrange
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.999,
            notes: '',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '10.999';

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.999,
            notes: '',
          ),
        ).called(1);
      });

      test('should handle price with leading/trailing spaces', () async {
        // Arrange
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 15.5,
            notes: '',
          ),
        ).thenAnswer((_) async => {});

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '  15.5  '; // Price with spaces

        // Act
        await cubit.placeBuyOrder();

        // Assert
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
        verify(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 15.5,
            notes: '',
          ),
        ).called(1);
      });

      test('should handle concurrent place order attempts', () async {
        // Arrange
        final completer = Completer<void>();
        when(
          mockPlaceBuyOrderUsecase.placeBuyOrder(
            itemId: 'item-1',
            price: 10.5,
            notes: '',
          ),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();
        cubit.selectedItem = testItem1;
        cubit.price = '10.5';

        // Act - Start first order
        final firstOrderFuture = cubit.placeBuyOrder();
        expect(cubit.state.isPlaceBuyOrderLoading, isTrue);

        // Try to start second order while first is in progress
        final secondOrderFuture = cubit.placeBuyOrder();

        // Complete the orders
        completer.complete();
        await firstOrderFuture;
        await secondOrderFuture;

        // Assert - Both should complete successfully
        expect(cubit.state.isPlaceBuyOrderLoading, isFalse);
        expect(showSuccessOrderCalled, isTrue);
      });
    });
  });
}
