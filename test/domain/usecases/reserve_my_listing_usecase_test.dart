import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/patch_my_market_request.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:dotagiftx_mobile/domain/usecases/reserve_my_listing_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reserve_my_listing_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxAuthApi>()])
void main() {
  group(ReserveMyListingUsecaseImpl, () {
    late MockDotagiftxAuthApi mockDotagiftxAuthApi;

    setUp(() {
      mockDotagiftxAuthApi = MockDotagiftxAuthApi();
    });

    ReserveMyListingUsecaseImpl createUnitToTest() {
      return ReserveMyListingUsecaseImpl(mockDotagiftxAuthApi);
    }

    group('reserve', () {
      const testMarketId = 'test-market-id-123';
      const testPartnerSteamId = 'https://steamcommunity.com/profiles/12345';
      const testNotes = 'Test reservation notes';

      test('should reserve listing successfully with notes', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusReserved,
              partnerSteamId: testPartnerSteamId,
              notes: testNotes,
            ),
          ),
        ).thenAnswer((_) async {});

        // Act
        await createUnitToTest().reserve(
          marketId: testMarketId,
          partnerSteamId: testPartnerSteamId,
          notes: testNotes,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusReserved,
              partnerSteamId: testPartnerSteamId,
              notes: testNotes,
            ),
          ),
        ).called(1);
      });

      test('should reserve listing successfully without notes', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusReserved,
              partnerSteamId: testPartnerSteamId,
              notes: null,
            ),
          ),
        ).thenAnswer((_) async {});

        // Act
        await createUnitToTest().reserve(
          marketId: testMarketId,
          partnerSteamId: testPartnerSteamId,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusReserved,
              partnerSteamId: testPartnerSteamId,
              notes: null,
            ),
          ),
        ).called(1);
      });

      test(
        'should throw NullPartnerSteamIdException when partnerSteamId is null',
        () async {
          // Act & Assert
          expect(
            () => createUnitToTest().reserve(
              marketId: testMarketId,
              partnerSteamId: '',
            ),
            throwsA(isA<NullPartnerSteamIdException>()),
          );

          verifyNever(mockDotagiftxAuthApi.patchMyMarket(any, any));
        },
      );

      test(
        'should throw InvalidUrlException when partnerSteamId is not a valid URL',
        () async {
          // Act & Assert
          expect(
            () => createUnitToTest().reserve(
              marketId: testMarketId,
              partnerSteamId: 'invalid-url',
            ),
            throwsA(isA<InvalidUrlException>()),
          );

          verifyNever(mockDotagiftxAuthApi.patchMyMarket(any, any));
        },
      );

      test(
        'should throw InvalidSteamIdUrlException when partnerSteamId does not start with steam base URL',
        () async {
          // Act & Assert
          expect(
            () => createUnitToTest().reserve(
              marketId: testMarketId,
              partnerSteamId: 'https://example.com/profiles/12345',
            ),
            throwsA(isA<InvalidSteamIdUrlException>()),
          );

          verifyNever(mockDotagiftxAuthApi.patchMyMarket(any, any));
        },
      );

      test('should throw exception when API call fails', () async {
        // Arrange
        final exception = Exception('API Error');
        when(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusReserved,
              partnerSteamId: testPartnerSteamId,
              notes: testNotes,
            ),
          ),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => createUnitToTest().reserve(
            marketId: testMarketId,
            partnerSteamId: testPartnerSteamId,
            notes: testNotes,
          ),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusReserved,
              partnerSteamId: testPartnerSteamId,
              notes: testNotes,
            ),
          ),
        ).called(1);
      });
    });
  });
}
