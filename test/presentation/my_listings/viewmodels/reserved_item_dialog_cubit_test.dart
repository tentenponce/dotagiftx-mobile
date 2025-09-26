import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/domain/usecases/cancel_reserve_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/deliver_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/reserved_item_dialog_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/reserved_item_dialog_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reserved_item_dialog_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<CancelReserveMyListingUsecase>(),
  MockSpec<DeliverMyListingUsecase>(),
])
void main() {
  group(ReservedItemDialogCubit, () {
    late MockLogger mockLogger;
    late MockCancelReserveMyListingUsecase mockCancelReserveMyListingUsecase;
    late MockDeliverMyListingUsecase mockDeliverMyListingUsecase;
    late bool dismissDialogCalled;
    late String? cancelReservationErrorMessage;
    late String? deliverItemErrorMessage;

    // Test data
    const testMarketId = 'test-market-id-123';
    const testNotes = 'Test notes for action';
    const testApiErrorMessage = 'API Error: Test error message';

    setUp(() {
      mockLogger = MockLogger();
      mockCancelReserveMyListingUsecase = MockCancelReserveMyListingUsecase();
      mockDeliverMyListingUsecase = MockDeliverMyListingUsecase();
      dismissDialogCalled = false;
      cancelReservationErrorMessage = null;
      deliverItemErrorMessage = null;
    });

    ReservedItemDialogCubit createUnitToTest() {
      final cubit = ReservedItemDialogCubit(
        mockLogger,
        mockCancelReserveMyListingUsecase,
        mockDeliverMyListingUsecase,
      );

      // Set up callback functions
      cubit.showCancelReservationError = (message) {
        cancelReservationErrorMessage = message;
      };
      cubit.showDeliverItemError = (message) {
        deliverItemErrorMessage = message;
      };
      cubit.dismissDialog = () {
        dismissDialogCalled = true;
      };

      return cubit;
    }

    group('cancelReservation', () {
      test('should complete cancel reservation successfully', () async {
        // Arrange
        when(
          mockCancelReserveMyListingUsecase.cancel(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).thenAnswer((_) => Future.value());

        final cubit = createUnitToTest();

        // Act
        await cubit.cancelReservation(marketId: testMarketId, notes: testNotes);

        // Assert
        expect(cubit.state.isCancelReservationLoading, isFalse);
        expect(dismissDialogCalled, isTrue);
        expect(cancelReservationErrorMessage, isNull);
        verify(
          mockCancelReserveMyListingUsecase.cancel(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).called(1);
      });

      test(
        'should complete cancel reservation successfully without notes',
        () async {
          // Arrange
          when(
            mockCancelReserveMyListingUsecase.cancel(
              marketId: testMarketId,
              notes: null,
            ),
          ).thenAnswer((_) => Future.value());

          final cubit = createUnitToTest();

          // Act
          await cubit.cancelReservation(marketId: testMarketId);

          // Assert
          expect(cubit.state.isCancelReservationLoading, isFalse);
          expect(dismissDialogCalled, isTrue);
          expect(cancelReservationErrorMessage, isNull);
          verify(
            mockCancelReserveMyListingUsecase.cancel(
              marketId: testMarketId,
              notes: null,
            ),
          ).called(1);
        },
      );

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
            mockCancelReserveMyListingUsecase.cancel(
              marketId: testMarketId,
              notes: testNotes,
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.cancelReservation(
            marketId: testMarketId,
            notes: testNotes,
          );

          // Assert
          expect(cubit.state.isCancelReservationLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(cancelReservationErrorMessage, equals(testApiErrorMessage));
          verify(
            mockCancelReserveMyListingUsecase.cancel(
              marketId: testMarketId,
              notes: testNotes,
            ),
          ).called(1);
        },
      );

      test(
        'should handle BadRequestException without API error message',
        () async {
          // Arrange
          final exception = BadRequestException(
            error: DioException(requestOptions: RequestOptions()),
            statusCode: 400,
          );
          when(
            mockCancelReserveMyListingUsecase.cancel(
              marketId: testMarketId,
              notes: testNotes,
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.cancelReservation(
            marketId: testMarketId,
            notes: testNotes,
          );

          // Assert
          expect(cubit.state.isCancelReservationLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(cancelReservationErrorMessage, equals(exception.toString()));
          verify(
            mockCancelReserveMyListingUsecase.cancel(
              marketId: testMarketId,
              notes: testNotes,
            ),
          ).called(1);
          verify(
            mockLogger.log(
              LogLevel.error,
              'Error canceling reservation',
              exception,
              any,
            ),
          ).called(1);
        },
      );

      test('should handle generic exception', () async {
        // Arrange
        final exception = Exception('Generic error');
        when(
          mockCancelReserveMyListingUsecase.cancel(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).thenThrow(exception);

        final cubit = createUnitToTest();

        // Act
        await cubit.cancelReservation(marketId: testMarketId, notes: testNotes);

        // Assert
        expect(cubit.state.isCancelReservationLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(cancelReservationErrorMessage, equals(exception.toString()));
        verify(
          mockCancelReserveMyListingUsecase.cancel(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).called(1);
        verify(
          mockLogger.log(
            LogLevel.error,
            'Error canceling reservation',
            exception,
            any,
          ),
        ).called(1);
      });

      test('should set loading state during cancel reservation', () async {
        // Arrange
        final completer = Completer<void>();
        when(
          mockCancelReserveMyListingUsecase.cancel(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();

        // Act
        final cancelFuture = cubit.cancelReservation(
          marketId: testMarketId,
          notes: testNotes,
        );

        // Assert loading state
        expect(cubit.state.isCancelReservationLoading, isTrue);

        // Complete the cancellation
        completer.complete();
        await cancelFuture;

        // Assert final state
        expect(cubit.state.isCancelReservationLoading, isFalse);
      });
    });

    group('deliverItem', () {
      test('should complete deliver item successfully', () async {
        // Arrange
        when(
          mockDeliverMyListingUsecase.deliver(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).thenAnswer((_) => Future.value());

        final cubit = createUnitToTest();

        // Act
        await cubit.deliverItem(marketId: testMarketId, notes: testNotes);

        // Assert
        expect(cubit.state.isDeliverItemLoading, isFalse);
        expect(dismissDialogCalled, isTrue);
        expect(deliverItemErrorMessage, isNull);
        verify(
          mockDeliverMyListingUsecase.deliver(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).called(1);
      });

      test('should complete deliver item successfully without notes', () async {
        // Arrange
        when(
          mockDeliverMyListingUsecase.deliver(
            marketId: testMarketId,
            notes: null,
          ),
        ).thenAnswer((_) => Future.value());

        final cubit = createUnitToTest();

        // Act
        await cubit.deliverItem(marketId: testMarketId);

        // Assert
        expect(cubit.state.isDeliverItemLoading, isFalse);
        expect(dismissDialogCalled, isTrue);
        expect(deliverItemErrorMessage, isNull);
        verify(
          mockDeliverMyListingUsecase.deliver(
            marketId: testMarketId,
            notes: null,
          ),
        ).called(1);
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
            mockDeliverMyListingUsecase.deliver(
              marketId: testMarketId,
              notes: testNotes,
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.deliverItem(marketId: testMarketId, notes: testNotes);

          // Assert
          expect(cubit.state.isDeliverItemLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(deliverItemErrorMessage, equals(testApiErrorMessage));
          verify(
            mockDeliverMyListingUsecase.deliver(
              marketId: testMarketId,
              notes: testNotes,
            ),
          ).called(1);
        },
      );

      test(
        'should handle BadRequestException without API error message',
        () async {
          // Arrange
          final exception = BadRequestException(
            error: DioException(requestOptions: RequestOptions()),
            statusCode: 400,
          );
          when(
            mockDeliverMyListingUsecase.deliver(
              marketId: testMarketId,
              notes: testNotes,
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.deliverItem(marketId: testMarketId, notes: testNotes);

          // Assert
          expect(cubit.state.isDeliverItemLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(deliverItemErrorMessage, equals(exception.toString()));
          verify(
            mockDeliverMyListingUsecase.deliver(
              marketId: testMarketId,
              notes: testNotes,
            ),
          ).called(1);
          verify(
            mockLogger.log(
              LogLevel.error,
              'Error delivering item',
              exception,
              any,
            ),
          ).called(1);
        },
      );

      test('should handle generic exception', () async {
        // Arrange
        final exception = Exception('Generic error');
        when(
          mockDeliverMyListingUsecase.deliver(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).thenThrow(exception);

        final cubit = createUnitToTest();

        // Act
        await cubit.deliverItem(marketId: testMarketId, notes: testNotes);

        // Assert
        expect(cubit.state.isDeliverItemLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(deliverItemErrorMessage, equals(exception.toString()));
        verify(
          mockDeliverMyListingUsecase.deliver(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).called(1);
        verify(
          mockLogger.log(
            LogLevel.error,
            'Error delivering item',
            exception,
            any,
          ),
        ).called(1);
      });

      test('should set loading state during deliver item', () async {
        // Arrange
        final completer = Completer<void>();
        when(
          mockDeliverMyListingUsecase.deliver(
            marketId: testMarketId,
            notes: testNotes,
          ),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();

        // Act
        final deliverFuture = cubit.deliverItem(
          marketId: testMarketId,
          notes: testNotes,
        );

        // Assert loading state
        expect(cubit.state.isDeliverItemLoading, isTrue);

        // Complete the delivery
        completer.complete();
        await deliverFuture;

        // Assert final state
        expect(cubit.state.isDeliverItemLoading, isFalse);
      });
    });

    group('state management', () {
      test('should have correct initial state', () {
        // Arrange & Act
        final cubit = createUnitToTest();

        // Assert
        expect(cubit.state, equals(const ReservedItemDialogState()));
        expect(cubit.state.isCancelReservationLoading, isFalse);
        expect(cubit.state.isDeliverItemLoading, isFalse);
      });
    });

    group('init', () {
      test('should complete init successfully', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        await cubit.init();

        // Assert - init method is empty, so just verify it completes without error
        expect(cubit.state, equals(const ReservedItemDialogState()));
      });
    });

    group('logger', () {
      test('should return correct logger instance', () {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        final logger = cubit.logger;

        // Assert
        expect(logger, equals(mockLogger));
      });
    });
  });
}
