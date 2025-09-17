import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:dotagiftx_mobile/domain/usecases/remove_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/reserve_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/my_active_listing_dialog_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/my_active_listing_dialog_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_active_listing_dialog_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<RemoveMyListingUsecase>(),
  MockSpec<ReserveMyListingUsecase>(),
])
void main() {
  group(MyActiveListingDialogCubit, () {
    late MockLogger mockLogger;
    late MockRemoveMyListingUsecase mockRemoveMyListingUsecase;
    late MockReserveMyListingUsecase mockReserveMyListingUsecase;
    late bool dismissDialogCalled;
    late String? removeListingErrorMessage;
    late bool showNullPartnerSteamIdErrorCalled;
    late bool showInvalidUrlErrorCalled;
    late bool showInvalidSteamIdUrlErrorCalled;
    late String? reserveErrorMessage;

    // Test data
    const testMarketId = 'test-market-id-123';
    const testPartnerSteamId = 'https://steamcommunity.com/profiles/12345';
    const testNotes = 'Test notes for reservation';
    const testApiErrorMessage = 'API Error: Test error message';

    setUp(() {
      mockLogger = MockLogger();
      mockRemoveMyListingUsecase = MockRemoveMyListingUsecase();
      mockReserveMyListingUsecase = MockReserveMyListingUsecase();
      dismissDialogCalled = false;
      removeListingErrorMessage = null;
      showNullPartnerSteamIdErrorCalled = false;
      showInvalidUrlErrorCalled = false;
      showInvalidSteamIdUrlErrorCalled = false;
      reserveErrorMessage = null;
    });

    MyActiveListingDialogCubit createUnitToTest() {
      final cubit = MyActiveListingDialogCubit(
        mockLogger,
        mockRemoveMyListingUsecase,
        mockReserveMyListingUsecase,
      );

      // Set up callback functions
      cubit.showRemoveListingError = (message) {
        removeListingErrorMessage = message;
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
      cubit.showReserveErrorMessage = (message) {
        reserveErrorMessage = message;
      };

      return cubit;
    }

    group('removeListing', () {
      test('should complete remove listing successfully', () async {
        // Arrange
        when(
          mockRemoveMyListingUsecase.remove(testMarketId),
        ).thenAnswer((_) => Future.value());

        final cubit = createUnitToTest();

        // Act
        await cubit.removeListing(testMarketId);

        // Assert
        expect(cubit.state.isRemoveListingLoading, isFalse);
        expect(dismissDialogCalled, isTrue);
        expect(removeListingErrorMessage, isNull);
        verify(mockRemoveMyListingUsecase.remove(testMarketId)).called(1);
      });

      test(
        'should handle BadRequestException with API error message',
        () async {
          // Arrange
          final exception = BadRequestException(
            error: DioException(requestOptions: RequestOptions()),
            apiErrorMessage: testApiErrorMessage,
          );
          when(
            mockRemoveMyListingUsecase.remove(testMarketId),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.removeListing(testMarketId);

          // Assert
          expect(cubit.state.isRemoveListingLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(removeListingErrorMessage, equals(testApiErrorMessage));
          verify(mockRemoveMyListingUsecase.remove(testMarketId)).called(1);
        },
      );

      test(
        'should handle BadRequestException without API error message',
        () async {
          // Arrange
          final exception = BadRequestException(
            error: DioException(requestOptions: RequestOptions()),
          );
          when(
            mockRemoveMyListingUsecase.remove(testMarketId),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.removeListing(testMarketId);

          // Assert
          expect(cubit.state.isRemoveListingLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(removeListingErrorMessage, equals(exception.toString()));
          verify(mockRemoveMyListingUsecase.remove(testMarketId)).called(1);
          verify(
            mockLogger.log(
              LogLevel.error,
              'Error removing listing',
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
        await cubit.removeListing(testMarketId);

        // Assert
        expect(cubit.state.isRemoveListingLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(removeListingErrorMessage, equals(exception.toString()));
        verify(mockRemoveMyListingUsecase.remove(testMarketId)).called(1);
        verify(
          mockLogger.log(
            LogLevel.error,
            'Error removing listing',
            exception,
            any,
          ),
        ).called(1);
      });

      test('should set loading state during remove listing', () async {
        // Arrange
        final completer = Completer<void>();
        when(
          mockRemoveMyListingUsecase.remove(testMarketId),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();

        // Act
        final removeFuture = cubit.removeListing(testMarketId);

        // Assert loading state
        expect(cubit.state.isRemoveListingLoading, isTrue);

        // Complete the removal
        completer.complete();
        await removeFuture;

        // Assert final state
        expect(cubit.state.isRemoveListingLoading, isFalse);
      });
    });

    group('reserveListing', () {
      test('should complete reserve listing successfully', () async {
        // Arrange
        when(
          mockReserveMyListingUsecase.reserve(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenAnswer((_) async {
          return;
        });

        final cubit = createUnitToTest();

        // Act
        await cubit.reserveListing(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isReserveListingLoading, isFalse);
        expect(dismissDialogCalled, isTrue);
        expect(reserveErrorMessage, isNull);
        verify(
          mockReserveMyListingUsecase.reserve(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).called(1);
      });

      test(
        'should complete reserve listing successfully without notes',
        () async {
          // Arrange
          when(
            mockReserveMyListingUsecase.reserve(
              marketId: testMarketId,
              partnerSteamId: testPartnerSteamId,
              notes: null,
            ),
          ).thenAnswer((_) async {
            return;
          });

          final cubit = createUnitToTest();

          // Act
          await cubit.reserveListing(testMarketId, testPartnerSteamId, null);

          // Assert
          expect(cubit.state.isReserveListingLoading, isFalse);
          expect(dismissDialogCalled, isTrue);
          expect(reserveErrorMessage, isNull);
          verify(
            mockReserveMyListingUsecase.reserve(
              marketId: testMarketId,
              partnerSteamId: testPartnerSteamId,
              notes: null,
            ),
          ).called(1);
        },
      );

      test('should handle NullPartnerSteamIdException', () async {
        // Arrange
        when(
          mockReserveMyListingUsecase.reserve(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenThrow(NullPartnerSteamIdException());

        final cubit = createUnitToTest();

        // Act
        await cubit.reserveListing(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isReserveListingLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(showNullPartnerSteamIdErrorCalled, isTrue);
        expect(reserveErrorMessage, isNull);
      });

      test('should handle InvalidUrlException', () async {
        // Arrange
        when(
          mockReserveMyListingUsecase.reserve(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenThrow(InvalidUrlException());

        final cubit = createUnitToTest();

        // Act
        await cubit.reserveListing(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isReserveListingLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(showInvalidUrlErrorCalled, isTrue);
        expect(reserveErrorMessage, isNull);
      });

      test('should handle InvalidSteamIdUrlException', () async {
        // Arrange
        when(
          mockReserveMyListingUsecase.reserve(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenThrow(InvalidSteamIdUrlException());

        final cubit = createUnitToTest();

        // Act
        await cubit.reserveListing(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isReserveListingLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(showInvalidSteamIdUrlErrorCalled, isTrue);
        expect(reserveErrorMessage, isNull);
      });

      test(
        'should handle BadRequestException with API error message',
        () async {
          // Arrange
          final exception = BadRequestException(
            error: DioException(requestOptions: RequestOptions()),
            apiErrorMessage: testApiErrorMessage,
          );
          when(
            mockReserveMyListingUsecase.reserve(
              marketId: testMarketId,
              partnerSteamId: testPartnerSteamId,
              notes: testNotes,
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.reserveListing(
            testMarketId,
            testPartnerSteamId,
            testNotes,
          );

          // Assert
          expect(cubit.state.isReserveListingLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(reserveErrorMessage, equals(testApiErrorMessage));
        },
      );

      test(
        'should handle BadRequestException without API error message',
        () async {
          // Arrange
          final exception = BadRequestException(
            error: DioException(requestOptions: RequestOptions()),
          );
          when(
            mockReserveMyListingUsecase.reserve(
              marketId: testMarketId,
              partnerSteamId: testPartnerSteamId,
              notes: testNotes,
            ),
          ).thenThrow(exception);

          final cubit = createUnitToTest();

          // Act
          await cubit.reserveListing(
            testMarketId,
            testPartnerSteamId,
            testNotes,
          );

          // Assert
          expect(cubit.state.isReserveListingLoading, isFalse);
          expect(dismissDialogCalled, isFalse);
          expect(reserveErrorMessage, equals(exception.toString()));
          verify(
            mockLogger.log(
              LogLevel.error,
              'Error reserving listing',
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
          mockReserveMyListingUsecase.reserve(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenThrow(exception);

        final cubit = createUnitToTest();

        // Act
        await cubit.reserveListing(testMarketId, testPartnerSteamId, testNotes);

        // Assert
        expect(cubit.state.isReserveListingLoading, isFalse);
        expect(dismissDialogCalled, isFalse);
        expect(reserveErrorMessage, equals(exception.toString()));
        verify(
          mockLogger.log(
            LogLevel.error,
            'Error reserving listing',
            exception,
            any,
          ),
        ).called(1);
      });

      test('should set loading state during reserve listing', () async {
        // Arrange
        final completer = Completer<void>();
        when(
          mockReserveMyListingUsecase.reserve(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
        ).thenAnswer((_) => completer.future);

        final cubit = createUnitToTest();

        // Act
        final reserveFuture = cubit.reserveListing(
          testMarketId,
          testPartnerSteamId,
          testNotes,
        );

        // Assert loading state
        expect(cubit.state.isReserveListingLoading, isTrue);

        // Complete the reservation
        completer.complete();
        await reserveFuture;

        // Assert final state
        expect(cubit.state.isReserveListingLoading, isFalse);
      });
    });

    group('state management', () {
      test('should have correct initial state', () {
        // Arrange & Act
        final cubit = createUnitToTest();

        // Assert
        expect(cubit.state, equals(const MyActiveListingDialogState()));
        expect(cubit.state.isRemoveListingLoading, isFalse);
        expect(cubit.state.isReserveListingLoading, isFalse);
      });
    });

    group('init', () {
      test('should complete init successfully', () async {
        // Arrange
        final cubit = createUnitToTest();

        // Act
        await cubit.init();

        // Assert - init method is empty, so just verify it completes without error
        expect(cubit.state, equals(const MyActiveListingDialogState()));
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
