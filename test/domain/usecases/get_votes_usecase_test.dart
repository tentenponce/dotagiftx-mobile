import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/models/vote_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_votes_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_votes_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>(), MockSpec<SharedPreferenceStorage>()])
void main() {
  group(GetVotesUsecaseImpl, () {
    late MockLogger mockLogger;
    late MockSharedPreferenceStorage mockSharedPreferenceStorage;
    late GetVotesUsecaseImpl usecase;

    setUp(() {
      mockLogger = MockLogger();
      mockSharedPreferenceStorage = MockSharedPreferenceStorage();
      usecase = GetVotesUsecaseImpl(mockLogger, mockSharedPreferenceStorage);
    });

    group('getVotes', () {
      test('should return votes from local storage', () async {
        // Arrange
        final voteKeys = [
          '${SharedPreferencesKeys.votes}feature_1',
          '${SharedPreferencesKeys.votes}feature_2',
          '${SharedPreferencesKeys.votes}feature_3',
        ];
        final expectedVotes = [
          const VoteModel(featureId: 'feature_1'),
          const VoteModel(featureId: 'feature_2'),
          const VoteModel(featureId: 'feature_3'),
        ];

        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => voteKeys);

        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).thenAnswer((_) async => true);
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_2',
          ),
        ).thenAnswer((_) async => true);
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_3',
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await usecase.getVotes();

        // Assert
        expect(result, equals(expectedVotes));
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_2',
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_3',
          ),
        ).called(1);
      });

      test('should return empty list when no votes exist', () async {
        // Arrange
        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => <String>[]);

        // Act
        final result = await usecase.getVotes();

        // Assert
        expect(result, isEmpty);
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
      });

      test('should filter out false votes', () async {
        // Arrange
        final voteKeys = [
          '${SharedPreferencesKeys.votes}feature_1',
          '${SharedPreferencesKeys.votes}feature_2',
          '${SharedPreferencesKeys.votes}feature_3',
        ];
        final expectedVotes = [
          const VoteModel(featureId: 'feature_1'),
          const VoteModel(featureId: 'feature_3'),
        ];

        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => voteKeys);

        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).thenAnswer((_) async => true);
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_2',
          ),
        ).thenAnswer((_) async => false);
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_3',
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await usecase.getVotes();

        // Assert
        expect(result, equals(expectedVotes));
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_2',
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_3',
          ),
        ).called(1);
      });

      test('should filter out null votes', () async {
        // Arrange
        final voteKeys = [
          '${SharedPreferencesKeys.votes}feature_1',
          '${SharedPreferencesKeys.votes}feature_2',
          '${SharedPreferencesKeys.votes}feature_3',
        ];
        final expectedVotes = [
          const VoteModel(featureId: 'feature_1'),
          const VoteModel(featureId: 'feature_3'),
        ];

        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => voteKeys);

        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).thenAnswer((_) async => true);
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_2',
          ),
        ).thenAnswer((_) async => null);
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_3',
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await usecase.getVotes();

        // Assert
        expect(result, equals(expectedVotes));
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_2',
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_3',
          ),
        ).called(1);
      });

      test('should handle special characters in feature ids', () async {
        // Arrange
        final voteKeys = [
          '${SharedPreferencesKeys.votes}feature_@#\$%',
          '${SharedPreferencesKeys.votes}feature_with_spaces and symbols',
        ];
        final expectedVotes = [
          const VoteModel(featureId: r'feature_@#$%'),
          const VoteModel(featureId: 'feature_with_spaces and symbols'),
        ];

        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => voteKeys);

        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_@#\$%',
          ),
        ).thenAnswer((_) async => true);
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_with_spaces and symbols',
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await usecase.getVotes();

        // Assert
        expect(result, equals(expectedVotes));
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_@#\$%',
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_with_spaces and symbols',
          ),
        ).called(1);
      });

      test('should handle empty feature id', () async {
        // Arrange
        final voteKeys = [
          SharedPreferencesKeys.votes,
          '${SharedPreferencesKeys.votes}feature_1',
        ];
        final expectedVotes = [
          const VoteModel(featureId: ''),
          const VoteModel(featureId: 'feature_1'),
        ];

        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => voteKeys);

        when(
          mockSharedPreferenceStorage.getValue<bool>(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => true);
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).thenAnswer((_) async => true);

        // Act
        final result = await usecase.getVotes();

        // Assert
        expect(result, equals(expectedVotes));
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).called(1);
      });

      test('should handle storage error when getting keys', () async {
        // Arrange
        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => usecase.getVotes(), throwsException);
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
      });

      test('should handle storage error when getting vote value', () async {
        // Arrange
        final voteKeys = [
          '${SharedPreferencesKeys.votes}feature_1',
          '${SharedPreferencesKeys.votes}feature_2',
        ];

        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => voteKeys);

        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).thenThrow(Exception('Storage error'));
        when(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_2',
          ),
        ).thenAnswer((_) async => true);

        // Act & Assert
        final result = await usecase.getVotes();
        expect(result, [const VoteModel(featureId: 'feature_2')]);
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
        verify(
          mockSharedPreferenceStorage.getValue<bool>(
            '${SharedPreferencesKeys.votes}feature_1',
          ),
        ).called(1);
        verify(
          mockLogger.log(
            LogLevel.error,
            'Error getting vote for ${SharedPreferencesKeys.votes}feature_1 in local storage',
            isA<Exception>(),
          ),
        ).called(1);
      });

      test('should handle large number of votes', () async {
        // Arrange
        final voteKeys = List.generate(
          100,
          (index) => '${SharedPreferencesKeys.votes}feature_$index',
        );
        final expectedVotes = List.generate(
          100,
          (index) => VoteModel(featureId: 'feature_$index'),
        );

        when(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).thenAnswer((_) async => voteKeys);

        for (var i = 0; i < 100; i++) {
          when(
            mockSharedPreferenceStorage.getValue<bool>(
              '${SharedPreferencesKeys.votes}feature_$i',
            ),
          ).thenAnswer((_) async => true);
        }

        // Act
        final result = await usecase.getVotes();

        // Assert
        expect(result, equals(expectedVotes));
        verify(
          mockSharedPreferenceStorage.getKeysWithPrefix(
            SharedPreferencesKeys.votes,
          ),
        ).called(1);
        for (var i = 0; i < 100; i++) {
          verify(
            mockSharedPreferenceStorage.getValue<bool>(
              '${SharedPreferencesKeys.votes}feature_$i',
            ),
          ).called(1);
        }
      });
    });
  });
}
