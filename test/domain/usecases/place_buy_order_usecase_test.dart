import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/data/requests/post_my_market_request.dart';
import 'package:dotagiftx_mobile/domain/usecases/place_buy_order_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'place_buy_order_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxAuthApi>()])
void main() {
  group(PlaceBuyOrderUsecaseImpl, () {
    late MockDotagiftxAuthApi mockDotagiftxAuthApi;

    // Test data
    const testItemId = 'test-item-id-123';
    const testPrice = 25.99;
    const testNotes = 'Test notes for buy order';
    const testApiErrorMessage = 'API Error: Test error message';

    setUp(() {
      mockDotagiftxAuthApi = MockDotagiftxAuthApi();
    });

    PlaceBuyOrderUsecaseImpl createUnitToTest() {
      return PlaceBuyOrderUsecaseImpl(mockDotagiftxAuthApi);
    }

    group('placeBuyOrder', () {
      test('should place buy order successfully with default values', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(itemId: testItemId, price: testPrice);

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test(
        'should place buy order successfully with provided values',
        () async {
          // Arrange
          when(
            mockDotagiftxAuthApi.postMyMarket(
              const PostMyMarketRequest(
                itemId: testItemId,
                price: testPrice,
                notes: testNotes,
                type: ApiConstants.queryMarketBid,
              ),
            ),
          ).thenAnswer((_) async => {});

          final usecase = createUnitToTest();

          // Act
          await usecase.placeBuyOrder(
            itemId: testItemId,
            price: testPrice,
            notes: testNotes,
          );

          // Assert
          verify(
            mockDotagiftxAuthApi.postMyMarket(
              const PostMyMarketRequest(
                itemId: testItemId,
                price: testPrice,
                notes: testNotes,
                type: ApiConstants.queryMarketBid,
              ),
            ),
          ).called(1);
        },
      );

      test('should handle null notes parameter', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: testItemId,
          price: testPrice,
          notes: null,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle empty string notes', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: testItemId,
          price: testPrice,
          notes: '',
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle zero price', () async {
        // Arrange
        const zeroPrice = 0.0;
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: zeroPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(itemId: testItemId, price: zeroPrice);

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: zeroPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle negative price', () async {
        // Arrange
        const negativePrice = -5.0;
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: negativePrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(itemId: testItemId, price: negativePrice);

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: negativePrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle very small price values', () async {
        // Arrange
        const smallPrice = 0.01;
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: smallPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: testItemId,
          price: smallPrice,
          notes: testNotes,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: smallPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle very large price values', () async {
        // Arrange
        const largePrice = 999999.99;
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: largePrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: testItemId,
          price: largePrice,
          notes: testNotes,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: largePrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle very long notes', () async {
        // Arrange
        final longNotes = 'A' * 1000; // Very long string
        when(
          mockDotagiftxAuthApi.postMyMarket(
            PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: longNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: testItemId,
          price: testPrice,
          notes: longNotes,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: longNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle special characters in notes', () async {
        // Arrange
        const specialNotes = 'Notes with émojis 🎮 and spëcial çhars!';
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: specialNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: testItemId,
          price: testPrice,
          notes: specialNotes,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: specialNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle empty item ID', () async {
        // Arrange
        const emptyItemId = '';
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: emptyItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: emptyItemId,
          price: testPrice,
          notes: testNotes,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: emptyItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle API exception', () async {
        // Arrange
        final exception = BadRequestException(
          error: DioException(requestOptions: RequestOptions()),
          apiErrorMessage: testApiErrorMessage,
          statusCode: 400,
        );

        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(
          () => usecase.placeBuyOrder(itemId: testItemId, price: testPrice),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle generic exception', () async {
        // Arrange
        final exception = Exception('Network error');

        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(
          () => usecase.placeBuyOrder(
            itemId: testItemId,
            price: testPrice,
            notes: testNotes,
          ),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle timeout exception', () async {
        // Arrange
        final exception = DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );

        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(
          () => usecase.placeBuyOrder(itemId: testItemId, price: testPrice),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle server error exception', () async {
        // Arrange
        final exception = DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 500,
            statusMessage: 'Internal Server Error',
          ),
        );

        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(
          () => usecase.placeBuyOrder(
            itemId: testItemId,
            price: testPrice,
            notes: testNotes,
          ),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle unauthorized exception', () async {
        // Arrange
        final exception = DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
            statusMessage: 'Unauthorized',
          ),
        );

        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(
          () => usecase.placeBuyOrder(itemId: testItemId, price: testPrice),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should use correct market type for buy orders', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: testItemId,
          price: testPrice,
          notes: testNotes,
        );

        // Assert - Verify that the correct market type (BID = 20) is used
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: 20, // ApiConstants.queryMarketBid
            ),
          ),
        ).called(1);
      });

      test('should handle decimal price precision', () async {
        // Arrange
        const precisePrice = 10.999;
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: precisePrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(itemId: testItemId, price: precisePrice);

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: precisePrice,
              notes: '',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle multiple consecutive buy orders', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.postMyMarket(any),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act - Place multiple buy orders
        await usecase.placeBuyOrder(
          itemId: 'item-1',
          price: 10.0,
          notes: 'First order',
        );
        await usecase.placeBuyOrder(
          itemId: 'item-2',
          price: 20.0,
          notes: 'Second order',
        );
        await usecase.placeBuyOrder(
          itemId: 'item-3',
          price: 30.0,
          notes: 'Third order',
        );

        // Assert - Verify all orders were placed
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: 'item-1',
              price: 10.0,
              notes: 'First order',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: 'item-2',
              price: 20.0,
              notes: 'Second order',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: 'item-3',
              price: 30.0,
              notes: 'Third order',
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });

      test('should handle whitespace in notes', () async {
        // Arrange
        const whitespaceNotes = '  \t  \n  ';
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: whitespaceNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.placeBuyOrder(
          itemId: testItemId,
          price: testPrice,
          notes: whitespaceNotes,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: whitespaceNotes,
              type: ApiConstants.queryMarketBid,
            ),
          ),
        ).called(1);
      });
    });
  });
}
