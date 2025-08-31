import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/patch_my_market_request.dart';
import 'package:dotagiftx_mobile/domain/usecases/remove_my_listing_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remove_my_listing_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxAuthApi>()])
void main() {
  group(RemoveMyListingUsecaseImpl, () {
    late MockDotagiftxAuthApi mockDotagiftxAuthApi;

    setUp(() {
      mockDotagiftxAuthApi = MockDotagiftxAuthApi();
    });

    RemoveMyListingUsecaseImpl createUnitToTest() {
      return RemoveMyListingUsecaseImpl(mockDotagiftxAuthApi);
    }

    group('remove', () {
      const testMarketId = 'test-market-id-123';

      test('should remove listing successfully', () async {
        // Arrange
        when(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusOrderRemoved,
            ),
          ),
        ).thenAnswer((_) async {});

        // Act
        await createUnitToTest().remove(testMarketId);

        // Assert
        verify(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusOrderRemoved,
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
              status: ApiConstants.queryMarketStatusOrderRemoved,
            ),
          ),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => createUnitToTest().remove(testMarketId),
          throwsA(equals(exception)),
        );

        verify(
          mockDotagiftxAuthApi.patchMyMarket(
            testMarketId,
            const PatchMyMarketRequest(
              status: ApiConstants.queryMarketStatusOrderRemoved,
            ),
          ),
        ).called(1);
      });
    });
  });
}
