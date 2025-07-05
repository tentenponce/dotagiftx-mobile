import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/config/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/treasures_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'treasures_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>(), MockSpec<DotagiftxRemoteConfig>()])
void main() {
  group(TreasuresCubit, () {
    late MockLogger mockLogger;
    late MockDotagiftxRemoteConfig mockDotagiftxRemoteConfig;

    // Test data
    const testTreasure1 = TreasureModel(
      name: 'Test Treasure 1',
      image: 'test_treasure_1.png',
      rarity: 'mythical',
      imageUrl: 'https://example.com/test_treasure_1.png',
    );

    const testTreasure2 = TreasureModel(
      name: 'Test Treasure 2',
      image: 'test_treasure_2.png',
      rarity: 'immortal',
      imageUrl: 'https://example.com/test_treasure_2.png',
    );

    const testTreasure3 = TreasureModel(
      name: 'Another Treasure',
      image: 'another_treasure.png',
      rarity: 'mythical',
      imageUrl: 'https://example.com/another_treasure.png',
    );

    const testTreasureWithNullName = TreasureModel(
      name: null,
      image: 'null_name_treasure.png',
      rarity: 'immortal',
      imageUrl: 'https://example.com/null_name_treasure.png',
    );

    setUp(() {
      mockLogger = MockLogger();
      mockDotagiftxRemoteConfig = MockDotagiftxRemoteConfig();
    });

    TreasuresCubit createUnitToTest() {
      return TreasuresCubit(mockLogger, mockDotagiftxRemoteConfig);
    }

    group('init', () {
      test('should load treasures successfully on construction', () async {
        // Arrange
        final treasures = [testTreasure1, testTreasure2];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        fakeAsync((async) {
          // Act
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getTreasures()).called(1);
          expect(treasuresCubit.state.treasures, equals(treasures));
        });
      });

      test('should handle error when loading treasures', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenThrow(Exception('Failed to load treasures'));

        fakeAsync((async) {
          // Act
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getTreasures()).called(1);
          expect(treasuresCubit.state.loadingTreasures, isFalse);
          expect(treasuresCubit.state.treasures, isEmpty);
        });
      });

      test(
        'should set loading state correctly during treasure loading',
        () async {
          // Arrange
          final treasures = [testTreasure1];
          when(
            mockDotagiftxRemoteConfig.getTreasures(),
          ).thenAnswer((_) async => treasures);

          // Track state changes
          final states = <bool>[];

          fakeAsync((async) {
            // Act
            final treasuresCubit = createUnitToTest();

            // Set up listener after creation but before first async cycle
            treasuresCubit.stream.listen((state) {
              states.add(state.loadingTreasures);
            });

            async.elapse(Duration.zero);

            // Assert
            expect(states, equals([true, false]));
          });
        },
      );
    });

    group('onSwipeToRefresh', () {
      test('should call getTreasures successfully', () async {
        // Arrange
        final treasures = [testTreasure1, testTreasure2];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        final treasuresCubit = createUnitToTest();

        // Act
        treasuresCubit.onSwipeToRefresh();

        // Assert - Should be called twice (once on init, once on refresh)
        verify(mockDotagiftxRemoteConfig.getTreasures()).called(2);
      });
    });

    group('searchTreasure', () {
      test('should show all treasures when search query is empty', () async {
        // Arrange
        final treasures = [testTreasure1, testTreasure2, testTreasure3];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        fakeAsync((async) {
          final treasuresCubit = createUnitToTest();
          async.elapse(Duration.zero);

          // Act
          treasuresCubit.searchTreasure('Test');
          treasuresCubit.searchTreasure('');

          // Assert
          expect(treasuresCubit.searchQuery, isEmpty);
          expect(treasuresCubit.state.treasures, equals(treasures));
        });
      });

      test('should filter treasures based on search query', () async {
        // Arrange
        final treasures = [testTreasure1, testTreasure2, testTreasure3];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        fakeAsync((async) {
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          treasuresCubit.searchTreasure('Test');

          // Assert
          expect(treasuresCubit.searchQuery, equals('Test'));
          expect(treasuresCubit.state.treasures.length, equals(2));
          expect(treasuresCubit.state.treasures, contains(testTreasure1));
          expect(treasuresCubit.state.treasures, contains(testTreasure2));
        });
      });

      test('should perform case-insensitive search', () async {
        // Arrange
        final treasures = [testTreasure1, testTreasure2, testTreasure3];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        fakeAsync((async) {
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          treasuresCubit.searchTreasure('TEST');

          // Assert
          expect(treasuresCubit.searchQuery, equals('TEST'));
          expect(treasuresCubit.state.treasures.length, equals(2));
          expect(treasuresCubit.state.treasures, contains(testTreasure1));
          expect(treasuresCubit.state.treasures, contains(testTreasure2));
        });
      });

      test('should handle partial matches', () async {
        // Arrange
        final treasures = [testTreasure1, testTreasure2, testTreasure3];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        fakeAsync((async) {
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          treasuresCubit.searchTreasure('Another');

          // Assert
          expect(treasuresCubit.searchQuery, equals('Another'));
          expect(treasuresCubit.state.treasures.length, equals(1));
          expect(treasuresCubit.state.treasures, contains(testTreasure3));
        });
      });

      test('should return empty results when no matches found', () async {
        // Arrange
        final treasures = [testTreasure1, testTreasure2, testTreasure3];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        fakeAsync((async) {
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          treasuresCubit.searchTreasure('NonExistent');

          // Assert
          expect(treasuresCubit.searchQuery, equals('NonExistent'));
          expect(treasuresCubit.state.treasures, isEmpty);
        });
      });

      test('should handle treasures with null names safely', () async {
        // Arrange
        final treasures = [
          testTreasure1,
          testTreasureWithNullName,
          testTreasure3,
        ];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        fakeAsync((async) {
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          treasuresCubit.searchTreasure('Test');

          // Assert
          expect(treasuresCubit.searchQuery, equals('Test'));
          expect(treasuresCubit.state.treasures.length, equals(1));
          expect(treasuresCubit.state.treasures, contains(testTreasure1));
          expect(
            treasuresCubit.state.treasures,
            isNot(contains(testTreasureWithNullName)),
          );
        });
      });

      test(
        'should update search query and filter results after initial load',
        () async {
          // Arrange
          final treasures = [testTreasure1, testTreasure2, testTreasure3];
          when(
            mockDotagiftxRemoteConfig.getTreasures(),
          ).thenAnswer((_) async => treasures);

          fakeAsync((async) {
            final treasuresCubit = createUnitToTest();

            async.elapse(Duration.zero);

            // Act & Assert - First search
            treasuresCubit.searchTreasure('Test');
            expect(treasuresCubit.searchQuery, equals('Test'));
            expect(treasuresCubit.state.treasures.length, equals(2));

            // Act & Assert - Second search
            treasuresCubit.searchTreasure('Another');
            expect(treasuresCubit.searchQuery, equals('Another'));
            expect(treasuresCubit.state.treasures.length, equals(1));

            // Act & Assert - Clear search
            treasuresCubit.searchTreasure('');
            expect(treasuresCubit.searchQuery, isEmpty);
            expect(treasuresCubit.state.treasures.length, equals(3));
          });
        },
      );
    });

    group('complex scenarios', () {
      test('should maintain search results after refresh', () async {
        // Arrange
        final treasures = [testTreasure1, testTreasure2, testTreasure3];
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => treasures);

        fakeAsync((async) {
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          treasuresCubit.searchTreasure('Test');
          expect(treasuresCubit.state.treasures.length, equals(2));

          treasuresCubit.onSwipeToRefresh();

          async.elapse(Duration.zero);

          // Assert
          expect(treasuresCubit.searchQuery, equals('Test'));
          expect(treasuresCubit.state.treasures.length, equals(2));
        });
      });

      test('should handle empty treasure list', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getTreasures(),
        ).thenAnswer((_) async => <TreasureModel>[]);

        fakeAsync((async) {
          final treasuresCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          treasuresCubit.searchTreasure('Test');

          // Assert
          expect(treasuresCubit.state.treasures, isEmpty);
          expect(treasuresCubit.searchQuery, equals('Test'));
        });
      });
    });
  });
}
