import 'dart:convert';

import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_user_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DotagiftxAuthApi>(),
  MockSpec<SharedPreferenceStorage>(),
])
void main() {
  group(GetUserUsecaseImpl, () {
    late MockDotagiftxAuthApi mockDotagiftxAuthApi;
    late MockSharedPreferenceStorage mockSharedPreferenceStorage;

    setUp(() {
      mockDotagiftxAuthApi = MockDotagiftxAuthApi();
      mockSharedPreferenceStorage = MockSharedPreferenceStorage();
    });

    GetUserUsecaseImpl createUnitToTest() {
      return GetUserUsecaseImpl(
        mockDotagiftxAuthApi,
        mockSharedPreferenceStorage,
      );
    }

    group('call', () {
      test('should return user successfully', () async {
        // Arrange
        const expectedUser = UserModel(
          name: 'Test User',
          url: 'https://steamcommunity.com/profiles/12345',
          avatar: 'https://example.com/avatar.png',
          createdAt: '2024-01-01T00:00:00Z',
          marketStats: MarketStats(
            live: 5,
            reserved: 2,
            sold: 10,
            bidCompleted: 3,
          ),
          subscription: 1,
          subscribedAt: '2024-01-01T00:00:00Z',
        );

        when(
          mockDotagiftxAuthApi.getUser(),
        ).thenAnswer((_) async => expectedUser);

        // Act
        final result = await createUnitToTest().call();

        // Assert
        expect(result, equals(expectedUser));
        verify(mockDotagiftxAuthApi.getUser()).called(1);
        verify(
          mockSharedPreferenceStorage.setValue(
            SharedPreferencesKeys.user,
            jsonEncode(expectedUser.toJson()),
          ),
        ).called(1);
      });
    });
  });
}
