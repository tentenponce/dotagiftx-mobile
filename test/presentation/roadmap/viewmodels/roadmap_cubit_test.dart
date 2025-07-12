import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/domain/models/vote_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_votes_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/submit_suggestion_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/submit_vote_usecase.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/viewmodels/roadmap_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'roadmap_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<DotagiftxRemoteConfig>(),
  MockSpec<GetVotesUsecase>(),
  MockSpec<SubmitVoteUsecase>(),
  MockSpec<SubmitSuggestionUsecase>(),
])
void main() {
  group(RoadmapCubit, () {
    late MockLogger mockLogger;
    late MockDotagiftxRemoteConfig mockDotagiftxRemoteConfig;
    late MockGetVotesUsecase mockGetVotesUsecase;
    late MockSubmitVoteUsecase mockSubmitVoteUsecase;
    late MockSubmitSuggestionUsecase mockSubmitSuggestionUsecase;

    // Test data
    const testRoadmapItem1 = RoadmapModel(
      id: 'test_feature_1',
      title: 'Test Feature 1',
      description: 'Description for test feature 1',
      icon: '0xe3b2',
      isCompleted: false,
      isActive: true,
      isVoted: false,
    );

    const testRoadmapItem2 = RoadmapModel(
      id: 'test_feature_2',
      title: 'Test Feature 2',
      description: 'Description for test feature 2',
      icon: '0xe450',
      isCompleted: true,
      isActive: false,
      isVoted: false,
    );

    const testRoadmapItem3 = RoadmapModel(
      id: 'test_feature_3',
      title: 'Test Feature 3',
      description: 'Description for test feature 3',
      icon: '0xe155',
      isCompleted: false,
      isActive: true,
      isVoted: false,
    );

    const testVote1 = VoteModel(
      userId: 'user_123',
      featureId: 'test_feature_1',
    );

    const testVote2 = VoteModel(
      userId: 'user_123',
      featureId: 'test_feature_3',
    );

    setUp(() {
      mockLogger = MockLogger();
      mockDotagiftxRemoteConfig = MockDotagiftxRemoteConfig();
      mockGetVotesUsecase = MockGetVotesUsecase();
      mockSubmitVoteUsecase = MockSubmitVoteUsecase();
      mockSubmitSuggestionUsecase = MockSubmitSuggestionUsecase();
    });

    RoadmapCubit createUnitToTest() {
      return RoadmapCubit(
        mockLogger,
        mockDotagiftxRemoteConfig,
        mockSubmitVoteUsecase,
        mockGetVotesUsecase,
        mockSubmitSuggestionUsecase,
      );
    }

    group('constructor', () {
      test('should initialize with default roadmap from remote config', () {
        // Act
        final roadmapCubit = createUnitToTest();

        // Assert
        expect(roadmapCubit.state.isNotEmpty, isTrue);
        expect(
          roadmapCubit.state.length,
          equals(4),
        ); // default roadmap has 4 items
        expect(roadmapCubit.state.first.id, equals('initial_login'));
      });
    });

    group('init', () {
      test('should load roadmap and votes successfully', () async {
        // Arrange
        final roadmapItems = [
          testRoadmapItem1,
          testRoadmapItem2,
          testRoadmapItem3,
        ];
        final votes = [testVote1, testVote2];

        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => roadmapItems);
        when(mockGetVotesUsecase.getVotes()).thenAnswer((_) async => votes);

        fakeAsync((async) {
          // Act
          final roadmapCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getRoadmap()).called(1);
          verify(mockGetVotesUsecase.getVotes()).called(1);

          expect(roadmapCubit.state.length, equals(3));
          expect(
            roadmapCubit.state.first.isVoted,
            isTrue,
          ); // testRoadmapItem1 should be voted
          expect(
            roadmapCubit.state[1].isVoted,
            isFalse,
          ); // testRoadmapItem2 should not be voted
          expect(
            roadmapCubit.state[2].isVoted,
            isTrue,
          ); // testRoadmapItem3 should be voted
        });
      });

      test('should handle roadmap loading error', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenThrow(Exception('Failed to load roadmap'));
        when(
          mockGetVotesUsecase.getVotes(),
        ).thenAnswer((_) async => <VoteModel>[]);

        fakeAsync((async) {
          // Act
          final roadmapCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getRoadmap()).called(1);
          // State should remain as default roadmap
          expect(roadmapCubit.state.length, equals(4));
        });
      });

      test('should handle votes loading error', () async {
        // Arrange
        final roadmapItems = [testRoadmapItem1, testRoadmapItem2];

        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => roadmapItems);
        when(
          mockGetVotesUsecase.getVotes(),
        ).thenThrow(Exception('Failed to load votes'));

        fakeAsync((async) {
          // Act
          final roadmapCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getRoadmap()).called(1);
          verify(mockGetVotesUsecase.getVotes()).called(1);
          // State should remain as default roadmap
          expect(roadmapCubit.state, roadmapItems);
        });
      });

      test('should handle empty roadmap', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => <RoadmapModel>[]);
        when(
          mockGetVotesUsecase.getVotes(),
        ).thenAnswer((_) async => <VoteModel>[]);

        fakeAsync((async) {
          // Act
          final roadmapCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getRoadmap()).called(1);
          verify(mockGetVotesUsecase.getVotes()).called(1);
          expect(roadmapCubit.state, isEmpty);
        });
      });

      test('should handle empty votes', () async {
        // Arrange
        final roadmapItems = [testRoadmapItem1, testRoadmapItem2];

        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => roadmapItems);
        when(
          mockGetVotesUsecase.getVotes(),
        ).thenAnswer((_) async => <VoteModel>[]);

        fakeAsync((async) {
          // Act
          final roadmapCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getRoadmap()).called(1);
          verify(mockGetVotesUsecase.getVotes()).called(1);

          expect(roadmapCubit.state.length, equals(2));
          expect(roadmapCubit.state.first.isVoted, isFalse);
          expect(roadmapCubit.state[1].isVoted, isFalse);
        });
      });
    });

    group('submitSuggestion', () {
      test('should submit suggestion successfully', () async {
        // Arrange
        const suggestion = 'Add dark mode support';
        when(
          mockSubmitSuggestionUsecase.submit(suggestion),
        ).thenAnswer((_) async => {});

        final roadmapCubit = createUnitToTest();

        // Act
        await roadmapCubit.submitSuggestion(suggestion);

        // Assert
        verify(mockSubmitSuggestionUsecase.submit(suggestion)).called(1);
      });

      test('should handle suggestion submission error gracefully', () async {
        // Arrange
        const suggestion = 'Add dark mode support';
        when(
          mockSubmitSuggestionUsecase.submit(suggestion),
        ).thenThrow(Exception('Failed to submit suggestion'));

        final roadmapCubit = createUnitToTest();

        // Act & Assert - Should not throw
        await expectLater(roadmapCubit.submitSuggestion(suggestion), completes);

        verify(mockSubmitSuggestionUsecase.submit(suggestion)).called(1);
      });

      test('should handle empty suggestion', () async {
        // Arrange
        const suggestion = '';
        when(
          mockSubmitSuggestionUsecase.submit(suggestion),
        ).thenAnswer((_) async => {});

        final roadmapCubit = createUnitToTest();

        // Act
        await roadmapCubit.submitSuggestion(suggestion);

        // Assert
        verify(mockSubmitSuggestionUsecase.submit(suggestion)).called(1);
      });
    });

    group('vote', () {
      test(
        'should perform optimistic update and submit vote successfully',
        () async {
          // Arrange
          const featureId = 'test_feature_1';
          final roadmapItems = [testRoadmapItem1, testRoadmapItem2];

          when(
            mockDotagiftxRemoteConfig.getRoadmap(),
          ).thenAnswer((_) async => roadmapItems);
          when(
            mockGetVotesUsecase.getVotes(),
          ).thenAnswer((_) async => <VoteModel>[]);
          when(
            mockSubmitVoteUsecase.vote(featureId),
          ).thenAnswer((_) async => {});

          fakeAsync((async) {
            final roadmapCubit = createUnitToTest();
            async.elapse(Duration.zero);

            // Act
            roadmapCubit.vote(featureId);

            // Assert - Optimistic update should happen immediately
            expect(roadmapCubit.state.first.isVoted, isTrue);
            expect(roadmapCubit.state[1].isVoted, isFalse);

            async.elapse(Duration.zero);

            // Assert - Vote should be submitted
            verify(mockSubmitVoteUsecase.vote(featureId)).called(1);
          });
        },
      );

      test(
        'should handle vote submission error gracefully without reverting optimistic update',
        () async {
          // Arrange
          const featureId = 'test_feature_1';
          final roadmapItems = [testRoadmapItem1, testRoadmapItem2];

          when(
            mockDotagiftxRemoteConfig.getRoadmap(),
          ).thenAnswer((_) async => roadmapItems);
          when(
            mockGetVotesUsecase.getVotes(),
          ).thenAnswer((_) async => <VoteModel>[]);
          when(
            mockSubmitVoteUsecase.vote(featureId),
          ).thenThrow(Exception('Failed to submit vote'));

          fakeAsync((async) {
            final roadmapCubit = createUnitToTest();
            async.elapse(Duration.zero);

            // Act
            roadmapCubit.vote(featureId);

            // Assert - Optimistic update should remain
            expect(roadmapCubit.state.first.isVoted, isTrue);
            expect(roadmapCubit.state[1].isVoted, isFalse);

            async.elapse(Duration.zero);

            // Assert - Vote submission should be attempted
            verify(mockSubmitVoteUsecase.vote(featureId)).called(1);
          });
        },
      );

      test('should only update the specific feature being voted on', () async {
        // Arrange
        const featureId = 'test_feature_2';
        final roadmapItems = [
          testRoadmapItem1,
          testRoadmapItem2,
          testRoadmapItem3,
        ];

        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => roadmapItems);
        when(
          mockGetVotesUsecase.getVotes(),
        ).thenAnswer((_) async => <VoteModel>[]);
        when(mockSubmitVoteUsecase.vote(featureId)).thenAnswer((_) async => {});

        fakeAsync((async) {
          final roadmapCubit = createUnitToTest();
          async.elapse(Duration.zero);

          // Act
          roadmapCubit.vote(featureId);

          // Assert - Only the second item should be voted
          expect(roadmapCubit.state[0].isVoted, isFalse);
          expect(roadmapCubit.state[1].isVoted, isTrue);
          expect(roadmapCubit.state[2].isVoted, isFalse);

          async.elapse(Duration.zero);

          verify(mockSubmitVoteUsecase.vote(featureId)).called(1);
        });
      });

      test('should handle vote for non-existent feature gracefully', () async {
        // Arrange
        const featureId = 'non_existent_feature';
        final roadmapItems = [testRoadmapItem1, testRoadmapItem2];

        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => roadmapItems);
        when(
          mockGetVotesUsecase.getVotes(),
        ).thenAnswer((_) async => <VoteModel>[]);
        when(mockSubmitVoteUsecase.vote(featureId)).thenAnswer((_) async => {});

        fakeAsync((async) {
          final roadmapCubit = createUnitToTest();
          async.elapse(Duration.zero);

          // Act
          roadmapCubit.vote(featureId);

          // Assert - No items should be voted
          expect(roadmapCubit.state[0].isVoted, isFalse);
          expect(roadmapCubit.state[1].isVoted, isFalse);

          async.elapse(Duration.zero);

          verify(mockSubmitVoteUsecase.vote(featureId)).called(1);
        });
      });

      test('should handle multiple votes on different features', () async {
        // Arrange
        final roadmapItems = [
          testRoadmapItem1,
          testRoadmapItem2,
          testRoadmapItem3,
        ];

        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => roadmapItems);
        when(
          mockGetVotesUsecase.getVotes(),
        ).thenAnswer((_) async => <VoteModel>[]);
        when(mockSubmitVoteUsecase.vote(any)).thenAnswer((_) async => {});

        fakeAsync((async) {
          final roadmapCubit = createUnitToTest();
          async.elapse(Duration.zero);

          // Act
          roadmapCubit.vote('test_feature_1');
          roadmapCubit.vote('test_feature_3');

          // Assert - Both items should be voted
          expect(roadmapCubit.state[0].isVoted, isTrue);
          expect(roadmapCubit.state[1].isVoted, isFalse);
          expect(roadmapCubit.state[2].isVoted, isTrue);

          async.elapse(Duration.zero);

          verify(mockSubmitVoteUsecase.vote('test_feature_1')).called(1);
          verify(mockSubmitVoteUsecase.vote('test_feature_3')).called(1);
        });
      });
    });

    group('complex scenarios', () {
      test('should handle init followed by votes correctly', () async {
        // Arrange
        final roadmapItems = [testRoadmapItem1, testRoadmapItem2];
        final votes = [testVote1];

        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => roadmapItems);
        when(mockGetVotesUsecase.getVotes()).thenAnswer((_) async => votes);
        when(mockSubmitVoteUsecase.vote(any)).thenAnswer((_) async => {});

        fakeAsync((async) {
          final roadmapCubit = createUnitToTest();
          async.elapse(Duration.zero);

          // Initial state - first item should be voted from init
          expect(roadmapCubit.state[0].isVoted, isTrue);
          expect(roadmapCubit.state[1].isVoted, isFalse);

          // Act - vote on second item
          roadmapCubit.vote('test_feature_2');

          // Assert - both items should be voted
          expect(roadmapCubit.state[0].isVoted, isTrue);
          expect(roadmapCubit.state[1].isVoted, isTrue);

          async.elapse(Duration.zero);

          verify(mockSubmitVoteUsecase.vote('test_feature_2')).called(1);
        });
      });

      test('should handle multiple suggestions submission', () async {
        // Arrange
        const suggestions = ['Feature 1', 'Feature 2', 'Feature 3'];
        when(
          mockSubmitSuggestionUsecase.submit(any),
        ).thenAnswer((_) async => {});

        final roadmapCubit = createUnitToTest();

        // Act
        for (final suggestion in suggestions) {
          await roadmapCubit.submitSuggestion(suggestion);
        }

        // Assert
        for (final suggestion in suggestions) {
          verify(mockSubmitSuggestionUsecase.submit(suggestion)).called(1);
        }
      });

      test('should handle vote on already voted feature', () async {
        // Arrange
        const featureId = 'test_feature_1';
        final roadmapItems = [testRoadmapItem1];
        final votes = [
          testVote1,
        ]; // This vote should make the feature already voted

        when(
          mockDotagiftxRemoteConfig.getRoadmap(),
        ).thenAnswer((_) async => roadmapItems);
        when(mockGetVotesUsecase.getVotes()).thenAnswer((_) async => votes);
        when(mockSubmitVoteUsecase.vote(featureId)).thenAnswer((_) async => {});

        fakeAsync((async) {
          final roadmapCubit = createUnitToTest();
          async.elapse(Duration.zero);

          // Initial state - already voted from init
          expect(roadmapCubit.state.first.isVoted, isTrue);

          // Act - vote again
          roadmapCubit.vote(featureId);

          // Assert - should still be voted
          expect(roadmapCubit.state.first.isVoted, isTrue);

          async.elapse(Duration.zero);

          verify(mockSubmitVoteUsecase.vote(featureId)).called(1);
        });
      });
    });
  });
}
