import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/data/responses/market_summary_response.dart';
import 'package:dotagiftx_mobile/domain/models/market_summary_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_market_summary_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_market_summary_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DotagiftxUnauthApi>(),
  MockSpec<KeychainStorage>(),
])
void main() {
  group(GetMarketSummaryUsecaseImpl, () {
    late MockDotagiftxUnauthApi mockDotagiftxUnauthApi;
    late MockKeychainStorage mockKeychainStorage;

    setUp(() {
      mockDotagiftxUnauthApi = MockDotagiftxUnauthApi();
      mockKeychainStorage = MockKeychainStorage();
    });

    GetMarketSummaryUsecaseImpl createUnitToTest() {
      return GetMarketSummaryUsecaseImpl(
        mockDotagiftxUnauthApi,
        mockKeychainStorage,
      );
    }

    group('get', () {
      test('should return market summary successfully', () async {
        // Arrange
        const steamId = '12345';
        const userId = '67890';

        const partnerSummaryResponse = MarketSummaryResponse(reserved: 3);

        const userSummaryResponse = MarketSummaryResponse(
          reserved: 4,
          sold: 15,
        );

        const ordersUserSummaryResponse = MarketSummaryResponse(
          bidCompleted: 7,
        );

        const expectedMarketSummary = MarketSummaryModel(
          reservedListings: 4, // userSummary.reserved
          deliveredListings: 15, // userSummary.sold
          toReceiveOrders: 3, // partnerSummary.reserved
          completedOrders: 7, // ordersUserSummary.bidCompleted
        );

        when(
          mockKeychainStorage.getValue(KeychainKeys.steamId),
        ).thenAnswer((_) async => steamId);
        when(
          mockKeychainStorage.getValue(KeychainKeys.userId),
        ).thenAnswer((_) async => userId);
        when(
          mockDotagiftxUnauthApi.getPartnerMarketSummary(steamId),
        ).thenAnswer((_) async => partnerSummaryResponse);
        when(
          mockDotagiftxUnauthApi.getUserMarketSummary(userId, null),
        ).thenAnswer((_) async => ordersUserSummaryResponse);
        when(
          mockDotagiftxUnauthApi.getUserMarketSummary(
            userId,
            ApiConstants.queryIndexUserId,
          ),
        ).thenAnswer((_) async => userSummaryResponse);

        // Act
        final result = await createUnitToTest().get();

        // Assert
        expect(result, equals(expectedMarketSummary));
        verify(mockKeychainStorage.getValue(KeychainKeys.steamId)).called(1);
        verify(mockKeychainStorage.getValue(KeychainKeys.userId)).called(1);
        verify(
          mockDotagiftxUnauthApi.getPartnerMarketSummary(steamId),
        ).called(1);
        verify(
          mockDotagiftxUnauthApi.getUserMarketSummary(userId, null),
        ).called(1);
        verify(
          mockDotagiftxUnauthApi.getUserMarketSummary(
            userId,
            ApiConstants.queryIndexUserId,
          ),
        ).called(1);
      });
    });
  });
}
