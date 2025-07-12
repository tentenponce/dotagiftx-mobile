import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_storage.dart';
import 'package:dotagiftx_mobile/domain/usecases/submit_vote_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'submit_vote_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DotagiftxStorage>(),
  MockSpec<SharedPreferenceStorage>(),
])
void main() {
  group(SubmitVoteUsecaseImpl, () {
    late MockDotagiftxStorage mockDotagiftxStorage;
    late MockSharedPreferenceStorage mockSharedPreferenceStorage;
    late SubmitVoteUsecaseImpl usecase;

    setUp(() {
      mockDotagiftxStorage = MockDotagiftxStorage();
      mockSharedPreferenceStorage = MockSharedPreferenceStorage();
      usecase = SubmitVoteUsecaseImpl(
        mockDotagiftxStorage,
        mockSharedPreferenceStorage,
      );
    });

    group('vote', () {
      test('should vote successfully and save to local storage', () async {
        // Arrange
        const featureId = 'test_feature_123';
        const expectedKey = SharedPreferencesKeys.votes + featureId;
        when(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).thenAnswer((_) async => true);
        when(
          mockDotagiftxStorage.submitVote(featureId),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.vote(featureId);

        // Assert
        verify(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).called(1);
        verify(mockDotagiftxStorage.submitVote(featureId)).called(1);
      });

      test('should vote with empty feature id', () async {
        // Arrange
        const featureId = '';
        const expectedKey = SharedPreferencesKeys.votes + featureId;
        when(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).thenAnswer((_) async => true);
        when(
          mockDotagiftxStorage.submitVote(featureId),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.vote(featureId);

        // Assert
        verify(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).called(1);
        verify(mockDotagiftxStorage.submitVote(featureId)).called(1);
      });

      test('should vote with special characters in feature id', () async {
        // Arrange
        const featureId = r'feature_@#$%^&*()_+-=[]{}|;:,.<>?';
        const expectedKey = SharedPreferencesKeys.votes + featureId;
        when(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).thenAnswer((_) async => true);
        when(
          mockDotagiftxStorage.submitVote(featureId),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.vote(featureId);

        // Assert
        verify(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).called(1);
        verify(mockDotagiftxStorage.submitVote(featureId)).called(1);
      });

      test(
        'should handle local storage error but continue with remote vote',
        () async {
          // Arrange
          const featureId = 'test_feature_123';
          const expectedKey = SharedPreferencesKeys.votes + featureId;
          when(
            mockSharedPreferenceStorage.setValue(expectedKey, true),
          ).thenThrow(Exception('Local storage error'));
          when(
            mockDotagiftxStorage.submitVote(featureId),
          ).thenAnswer((_) async => {});

          // Act & Assert
          expect(() => usecase.vote(featureId), throwsException);
          verify(
            mockSharedPreferenceStorage.setValue(expectedKey, true),
          ).called(1);
          verifyNever(mockDotagiftxStorage.submitVote(featureId));
        },
      );

      test('should save to local storage and submit remote vote', () async {
        // Arrange
        const featureId = 'test_feature_123';
        const expectedKey = SharedPreferencesKeys.votes + featureId;
        when(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).thenAnswer((_) async => true);
        when(
          mockDotagiftxStorage.submitVote(featureId),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.vote(featureId);

        // Assert
        verify(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).called(1);
        verify(mockDotagiftxStorage.submitVote(featureId)).called(1);
      });

      test('should handle long feature id', () async {
        // Arrange
        const featureId =
            'this_is_a_very_long_feature_id_that_could_potentially_'
            'cause_issues_with_storage_or_network_requests_but_should_be_'
            'handled_gracefully_by_the_system';
        const expectedKey = SharedPreferencesKeys.votes + featureId;
        when(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).thenAnswer((_) async => true);
        when(
          mockDotagiftxStorage.submitVote(featureId),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.vote(featureId);

        // Assert
        verify(
          mockSharedPreferenceStorage.setValue(expectedKey, true),
        ).called(1);
        verify(mockDotagiftxStorage.submitVote(featureId)).called(1);
      });

      test('should handle multiple votes for different features', () async {
        // Arrange
        const featureId1 = 'feature_1';
        const featureId2 = 'feature_2';
        const expectedKey1 = SharedPreferencesKeys.votes + featureId1;
        const expectedKey2 = SharedPreferencesKeys.votes + featureId2;

        when(
          mockSharedPreferenceStorage.setValue(expectedKey1, true),
        ).thenAnswer((_) async => true);
        when(
          mockSharedPreferenceStorage.setValue(expectedKey2, true),
        ).thenAnswer((_) async => true);
        when(
          mockDotagiftxStorage.submitVote(featureId1),
        ).thenAnswer((_) async => {});
        when(
          mockDotagiftxStorage.submitVote(featureId2),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.vote(featureId1);
        await usecase.vote(featureId2);

        // Assert
        verify(
          mockSharedPreferenceStorage.setValue(expectedKey1, true),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.setValue(expectedKey2, true),
        ).called(1);
        verify(mockDotagiftxStorage.submitVote(featureId1)).called(1);
        verify(mockDotagiftxStorage.submitVote(featureId2)).called(1);
      });

      test(
        'should handle voting for the same feature multiple times',
        () async {
          // Arrange
          const featureId = 'duplicate_feature';
          const expectedKey = SharedPreferencesKeys.votes + featureId;
          when(
            mockSharedPreferenceStorage.setValue(expectedKey, true),
          ).thenAnswer((_) async => true);
          when(
            mockDotagiftxStorage.submitVote(featureId),
          ).thenAnswer((_) async => {});

          // Act
          await usecase.vote(featureId);
          await usecase.vote(featureId);

          // Assert
          verify(
            mockSharedPreferenceStorage.setValue(expectedKey, true),
          ).called(2);
          verify(mockDotagiftxStorage.submitVote(featureId)).called(2);
        },
      );
    });
  });
}
