import 'package:dio/dio.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/data/requests/post_my_market_request.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:dotagiftx_mobile/domain/usecases/post_listing_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_listing_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxAuthApi>()])
void main() {
  group(PostListingUsecaseImpl, () {
    late MockDotagiftxAuthApi mockDotagiftxAuthApi;

    // Test data
    const testItemId = 'test-item-id-123';
    const testPrice = 15.99;
    const testNotes = 'Test notes for listing';
    const testApiErrorMessage = 'API Error: Test error message';

    setUp(() {
      mockDotagiftxAuthApi = MockDotagiftxAuthApi();
    });

    PostListingUsecaseImpl createUnitToTest() {
      return PostListingUsecaseImpl(mockDotagiftxAuthApi);
    }

    group('post', () {
      test(
        'should post single listing successfully with default values',
        () async {
          // Arrange
          when(
            mockDotagiftxAuthApi.postMyMarket(
              const PostMyMarketRequest(
                itemId: testItemId,
                price: testPrice,
                notes: '',
                type: ApiConstants.queryMarketAsk,
              ),
            ),
          ).thenAnswer((_) async => {});

          final usecase = createUnitToTest();

          // Act
          await usecase.post(itemId: testItemId, price: testPrice);

          // Assert
          verify(
            mockDotagiftxAuthApi.postMyMarket(
              const PostMyMarketRequest(
                itemId: testItemId,
                price: testPrice,
                notes: '',
                type: ApiConstants.queryMarketAsk,
              ),
            ),
          ).called(1);
        },
      );

      test(
        'should post single listing successfully with provided values',
        () async {
          // Arrange
          when(
            mockDotagiftxAuthApi.postMyMarket(
              const PostMyMarketRequest(
                itemId: testItemId,
                price: testPrice,
                notes: testNotes,
                type: ApiConstants.queryMarketAsk,
              ),
            ),
          ).thenAnswer((_) async => {});

          final usecase = createUnitToTest();

          // Act
          await usecase.post(
            itemId: testItemId,
            price: testPrice,
            notes: testNotes,
            quantity: 1,
          );

          // Assert
          verify(
            mockDotagiftxAuthApi.postMyMarket(
              const PostMyMarketRequest(
                itemId: testItemId,
                price: testPrice,
                notes: testNotes,
                type: ApiConstants.queryMarketAsk,
              ),
            ),
          ).called(1);
        },
      );

      test('should post multiple listings when quantity > 1', () async {
        // Arrange
        const quantity = 3;
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.post(
          itemId: testItemId,
          price: testPrice,
          notes: testNotes,
          quantity: quantity,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).called(quantity);
      });

      test('should handle null notes parameter', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.post(itemId: testItemId, price: testPrice, notes: null);

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).called(1);
      });

      test('should handle null quantity parameter (defaults to 1)', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.post(
          itemId: testItemId,
          price: testPrice,
          notes: testNotes,
          quantity: null,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).called(1);
      });

      test(
        'should throw InvalidQuantityException when quantity is 0',
        () async {
          // Arrange
          final usecase = createUnitToTest();

          // Act & Assert
          expect(
            () =>
                usecase.post(itemId: testItemId, price: testPrice, quantity: 0),
            throwsA(isA<InvalidQuantityException>()),
          );

          verifyNever(mockDotagiftxAuthApi.postMyMarket(any));
        },
      );

      test(
        'should throw InvalidQuantityException when quantity is negative',
        () async {
          // Arrange
          final usecase = createUnitToTest();

          // Act & Assert
          expect(
            () => usecase.post(
              itemId: testItemId,
              price: testPrice,
              quantity: -5,
            ),
            throwsA(isA<InvalidQuantityException>()),
          );

          verifyNever(mockDotagiftxAuthApi.postMyMarket(any));
        },
      );

      test('should handle API exception during single posting', () async {
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
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(
          () => usecase.post(itemId: testItemId, price: testPrice),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).called(1);
      });

      test('should handle API exception during multiple posting', () async {
        // Arrange
        const quantity = 3;
        final exception = Exception('Network error');

        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(
          () => usecase.post(
            itemId: testItemId,
            price: testPrice,
            quantity: quantity,
          ),
          throwsA(equals(exception)),
        );

        // Should fail on first attempt
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).called(1);
      });

      test('should handle partial failure during multiple posting', () async {
        // Arrange
        const quantity = 3;
        final exception = Exception('Network error on first call');

        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).thenThrow(exception);

        final usecase = createUnitToTest();

        // Act & Assert
        expect(
          () => usecase.post(
            itemId: testItemId,
            price: testPrice,
            quantity: quantity,
          ),
          throwsA(equals(exception)),
        );

        // Should fail on first attempt
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).called(1);
      });

      test('should handle large quantity posting', () async {
        // Arrange
        const largeQuantity = 10;
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.post(
          itemId: testItemId,
          price: testPrice,
          notes: testNotes,
          quantity: largeQuantity,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: testNotes,
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).called(largeQuantity);
      });

      test('should handle empty string notes', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.post(itemId: testItemId, price: testPrice, notes: '');

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: testPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
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
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).thenAnswer((_) async => {});

        final usecase = createUnitToTest();

        // Act
        await usecase.post(itemId: testItemId, price: zeroPrice);

        // Assert
        verify(
          mockDotagiftxAuthApi.postMyMarket(
            const PostMyMarketRequest(
              itemId: testItemId,
              price: zeroPrice,
              notes: '',
              type: ApiConstants.queryMarketAsk,
            ),
          ),
        ).called(1);
      });
    });
  });
}
