import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/patch_my_market_request.dart';
import 'package:dotagiftx_mobile/domain/usecases/deliver_my_listing_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deliver_my_listing_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxAuthApi>()])
void main() {
  group(DeliverMyListingUsecaseImpl, () {
    late MockDotagiftxAuthApi mockDotagiftxAuthApi;

    setUp(() {
      mockDotagiftxAuthApi = MockDotagiftxAuthApi();
    });

    DeliverMyListingUsecaseImpl createUnitToTest() {
      return DeliverMyListingUsecaseImpl(mockDotagiftxAuthApi);
    }

    group('deliver', () {
      const testMarketId = 'test-market-id-123';
      const testNotes = 'Test delivery notes';

      test('should deliver item successfully with notes', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusSold,
              notes: testNotes,
            ),
          ),
        ).thenAnswer((_) async {});

        // Act
        await createUnitToTest().deliver(
          marketId: testMarketId,
          notes: testNotes,
        );

        // Assert
        verify(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusSold,
              notes: testNotes,
            ),
          ),
        ).called(1);
      });

      test('should deliver item successfully without notes', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusSold,
              notes: null,
            ),
          ),
        ).thenAnswer((_) async {});

        // Act
        await createUnitToTest().deliver(marketId: testMarketId);

        // Assert
        verify(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusSold,
              notes: null,
            ),
          ),
        ).called(1);
      });

      test('should throw exception when API call fails', () async {
        // Arrange
        final exception = Exception('API Error');
        when(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusSold,
              notes: testNotes,
            ),
          ),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => createUnitToTest().deliver(
            marketId: testMarketId,
            notes: testNotes,
          ),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusSold,
              notes: testNotes,
            ),
          ),
        ).called(1);
      });
    });
  });
}
