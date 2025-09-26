import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:dotagiftx_mobile/domain/usecases/complete_order_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/remove_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/states/my_order_dialog_state.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/viewmodels/my_order_dialog_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_order_dialog_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<RemoveMyListingUsecase>(),
  MockSpec<CompleteOrderUsecase>(),
])
void main() {
  group(MyOrderDialogCubit, () {
    late MockLogger mockLogger;
    late MockRemoveMyListingUsecase mockRemoveMyListingUsecase;
    late MockCompleteOrderUsecase mockCompleteOrderUsecase;
    late bool dismissDialogCalled;
    late String? removeOrderErrorMessage;
    late bool showNullPartnerSteamIdErrorCalled;
    late bool showInvalidUrlErrorCalled;
    late bool showInvalidSteamIdUrlErrorCalled;
    late String? completeOrderErrorMessage;

    // Test data
    const testMarketId = 'test-market-id-123';
    const testPartnerSteamId = 'https://steamcommunity.com/profiles/12345';
    const testNotes = 'Test notes for reservation';
    const testApiErrorMessage = 'API Error: Test error message';

    setUp(() {
      mockLogger = MockLogger();
      mockRemoveMyListingUsecase = MockRemoveMyListingUsecase();
      mockCompleteOrderUsecase = MockCompleteOrderUsecase();
      dismissDialogCalled = false;
      removeOrderErrorMessage = null;
      showNullPartnerSteamIdErrorCalled = false;
      showInvalidUrlErrorCalled = false;
      showInvalidSteamIdUrlErrorCalled = false;
      completeOrderErrorMessage = null;
    });

    MyOrderDialogCubit createUnitToTest() {
      final cubit = MyOrderDialogCubit(
        mockLogger,
        mockRemoveMyListingUsecase,
        mockCompleteOrderUsecase,
      );

      // Set up callback functions
      cubit.showRemoveOrderError = (message) {
        removeOrderErrorMessage = message;
      };
      cubit.dismissDialog = () {
        dismissDialogCalled = true;
      };
      cubit.showNullPartnerSteamIdError = () {
        showNullPartnerSteamIdErrorCalled = true;
      };
      cubit.showInvalidUrlError = () {
        showInvalidUrlErrorCalled = true;
      };
      cubit.showInvalidSteamIdUrlError = () {
        showInvalidSteamIdUrlErrorCalled = true;
      };
      cubit.showCompleteOrderErrorMessage = (message) {
        completeOrderErrorMessage = message;
      };

      return cubit;
    }

    group('removeOrder', () {
      test('should complete remove order successfully', () async {
        // Arrange
        when(
          mockRemoveMyListingUsecase.remove(testMarketId),
        ).thenAnswer((_) => Future.value());

        final cubit = createUnitToTest();

        // Act
        await cubit.removeOrder(testMarketId);

        // Assert
        expect(cubit.state.isRemoveOrderLoading, isFalse);
        expect(dismissDialogCalled, isTrue);
        expect(removeOrderErrorMessage, isNull);
        verify(mockRemoveMyListingUsecase.remove(testMarketId)).called(1);
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
            mockRemoveMyListingUsecase.remove(testMarketId),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.removeOrder(testMarketId);

          // Assert
          expect(cubit.state.isRemoveOrderLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(removeOrderErrorMessage, equals(testApiErrorMessage));
          verify(mockRemoveMyListingUsecase.remove(testMarketId)).called(1);
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
            mockRemoveMyListingUsecase.remove(testMarketId),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.removeOrder(testMarketId);

          // Assert
          expect(cubit.state.isRemoveOrderLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(removeOrderErrorMessage, equals(exception.toString()));
          verify(mockRemoveMyListingUsecase.remove(testMarketId)).called(1);
          verify(
            mockLogger.log(
              LogLevel.error,
              'Error removing order',
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
          mockRemoveMyListingUsecase.remove(testMarketId),
        ).thenThrow(exception);

        final cubit = createUnitToTest();

        // Act
        await cubit.removeOrder(testMarketId);

        // Assert
        expect(cubit.state.isRemoveOrderLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(removeOrderErrorMessage, equals(exception.toString()));
        verify(mockRemoveMyListingUsecase.remove(testMarketId)).called(1);
        verify(
          mockLogger.log(
            LogLevel.error,
            'Error removing order',
            exception,
            any,
          ),
        ).called(1);
      });

      test('should set loading state during remove order', () async {
        // Arrange
        final completer = Completer<void>();
        when(
          mockRemoveMyListingUsecase.remove(testMarketId),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();

        // Act
        final removeFuture = cubit.removeOrder(testMarketId);

        // Assert loading state
        expect(cubit.state.isRemoveOrderLoading, isTrue);

        // Complete the removal
        completer.complete();
        await removeFuture;

        // Assert final state
        expect(cubit.state.isRemoveOrderLoading, isFalse);
      });
    });

    group('completeOrder', () {
      test('should complete order successfully', () async {
        // Arrange
        when(
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenAnswer((_) async {
          return;
        });

        final cubit = createUnitToTest();

        // Act
        await cubit.completeOrder(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isCompleteOrderLoading, isFalse);
        expect(dismissDialogCalled, isTrue);
        expect(completeOrderErrorMessage, isNull);
        verify(
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).called(1);
      });

      test('should complete order successfully without notes', () async {
        // Arrange
        when(
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: null,
          ),
        ).thenAnswer((_) async {
          return;
        });

        final cubit = createUnitToTest();

        // Act
        await cubit.completeOrder(testMarketId, testPartnerSteamId, null);

        // Assert
        expect(cubit.state.isCompleteOrderLoading, isFalse);
        expect(dismissDialogCalled, isTrue);
        expect(completeOrderErrorMessage, isNull);
        verify(
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: null,
          ),
        ).called(1);
      });

      test('should handle NullPartnerSteamIdException', () async {
        // Arrange
        when(
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenThrow(NullPartnerSteamIdException());

        final cubit = createUnitToTest();

        // Act
        await cubit.completeOrder(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isCompleteOrderLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(showNullPartnerSteamIdErrorCalled, isTrue);
        expect(completeOrderErrorMessage, isNull);
      });

      test('should handle InvalidUrlException', () async {
        // Arrange
        when(
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenThrow(InvalidUrlException());

        final cubit = createUnitToTest();

        // Act
        await cubit.completeOrder(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isCompleteOrderLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(showInvalidUrlErrorCalled, isTrue);
        expect(completeOrderErrorMessage, isNull);
      });

      test('should handle InvalidSteamIdUrlException', () async {
        // Arrange
        when(
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenThrow(InvalidSteamIdUrlException());

        final cubit = createUnitToTest();

        // Act
        await cubit.completeOrder(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isCompleteOrderLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(showInvalidSteamIdUrlErrorCalled, isTrue);
        expect(completeOrderErrorMessage, isNull);
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
            mockCompleteOrderUsecase.complete(
              marketId: testMarketId,
              partnerSteamId: testPartnerSteamId,
              notes: testNotes,
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.completeOrder(
            testMarketId,
            testPartnerSteamId,
            testNotes,
          );

          // Assert
          expect(cubit.state.isCompleteOrderLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(completeOrderErrorMessage, equals(testApiErrorMessage));
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
            mockCompleteOrderUsecase.complete(
              marketId: testMarketId,
              partnerSteamId: testPartnerSteamId,
              notes: testNotes,
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.completeOrder(
            testMarketId,
            testPartnerSteamId,
            testNotes,
          );

          // Assert
          expect(cubit.state.isCompleteOrderLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(completeOrderErrorMessage, equals(exception.toString()));
          verify(
            mockLogger.log(
              LogLevel.error,
              'Error completing order',
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
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenThrow(exception);

        final cubit = createUnitToTest();

        // Act
        await cubit.completeOrder(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isCompleteOrderLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(completeOrderErrorMessage, equals(exception.toString()));
        verify(
          mockLogger.log(
            LogLevel.error,
            'Error completing order',
            exception,
            any,
          ),
        ).called(1);
      });

      test('should set loading state during complete order', () async {
        // Arrange
        final completer = Completer<void>();
        when(
          mockCompleteOrderUsecase.complete(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();

        // Act
        final completeFuture = cubit.completeOrder(
          testMarketId,
          testPartnerSteamId,
          testNotes,
        );

        // Assert loading state
        expect(cubit.state.isCompleteOrderLoading, isTrue);

        // Complete the complete order
        completer.complete();
        await completeFuture;

        // Assert final state
        expect(cubit.state.isCompleteOrderLoading, isFalse);
      });
    });

    group('state management', () {
      test('should have correct initial state', () {
        // Arrange & Act
        final cubit = createUnitToTest();

        // Assert
        expect(cubit.state, equals(const MyOrderDialogState()));
        expect(cubit.state.isRemoveOrderLoading, isFalse);
        expect(cubit.state.isCompleteOrderLoading, isFalse);
      });
    });

    group('init', () {
      test('should complete init successfully', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        await cubit.init();

        // Assert - init method is empty, so just verify it completes without error
        expect(cubit.state, equals(const MyOrderDialogState()));
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
