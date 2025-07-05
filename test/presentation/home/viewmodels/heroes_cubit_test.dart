import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/config/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/models/hero_model.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/heroes_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'heroes_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Logger>(), MockSpec<DotagiftxRemoteConfig>()])
void main() {
  group(HeroesCubit, () {
    late MockLogger mockLogger;
    late MockDotagiftxRemoteConfig mockDotagiftxRemoteConfig;

    // Test data
    const testHero1 = HeroModel(
      name: 'Test Hero 1',
      heroImage: 'https://example.com/test_hero_1.png',
      attributeIcon: 'https://example.com/strength.png',
    );

    const testHero2 = HeroModel(
      name: 'Test Hero 2',
      heroImage: 'https://example.com/test_hero_2.png',
      attributeIcon: 'https://example.com/agility.png',
    );

    const testHero3 = HeroModel(
      name: 'Another Hero',
      heroImage: 'https://example.com/another_hero.png',
      attributeIcon: 'https://example.com/intelligence.png',
    );

    const testHeroWithNullName = HeroModel(
      name: null,
      heroImage: 'https://example.com/null_name_hero.png',
      attributeIcon: 'https://example.com/universal.png',
    );

    setUp(() {
      mockLogger = MockLogger();
      mockDotagiftxRemoteConfig = MockDotagiftxRemoteConfig();
    });

    HeroesCubit createUnitToTest() {
      return HeroesCubit(mockLogger, mockDotagiftxRemoteConfig);
    }

    group('init', () {
      test('should load heroes successfully on construction', () async {
        // Arrange
        final heroes = [testHero1, testHero2];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        fakeAsync((async) {
          // Act
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getHeroes()).called(1);
          expect(heroesCubit.state.heroes, equals(heroes));
        });
      });

      test('should handle error when loading heroes', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenThrow(Exception('Failed to load heroes'));

        fakeAsync((async) {
          // Act
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Assert
          verify(mockDotagiftxRemoteConfig.getHeroes()).called(1);
          expect(heroesCubit.state.loadingHeroes, isFalse);
          expect(heroesCubit.state.heroes, isEmpty);
        });
      });

      test('should set loading state correctly during hero loading', () async {
        // Arrange
        final heroes = [testHero1];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        // Track state changes
        final states = <bool>[];

        fakeAsync((async) {
          // Act
          final heroesCubit = createUnitToTest();

          // Set up listener after creation but before first async cycle
          heroesCubit.stream.listen((state) {
            states.add(state.loadingHeroes);
          });

          async.elapse(Duration.zero);

          // Assert
          expect(states, equals([true, false]));
        });
      });
    });

    group('onSwipeToRefresh', () {
      test('should call getHeroes successfully', () async {
        // Arrange
        final heroes = [testHero1, testHero2];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        final heroesCubit = createUnitToTest();

        // Act
        heroesCubit.onSwipeToRefresh();

        // Assert - Should be called twice (once on init, once on refresh)
        verify(mockDotagiftxRemoteConfig.getHeroes()).called(2);
      });
    });

    group('searchHero', () {
      test('should show all heroes when search query is empty', () async {
        // Arrange
        final heroes = [testHero1, testHero2, testHero3];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        fakeAsync((async) {
          final heroesCubit = createUnitToTest();
          async.elapse(Duration.zero);

          // Act
          heroesCubit.searchHero('Test');
          heroesCubit.searchHero('');

          // Assert
          expect(heroesCubit.searchQuery, isEmpty);
          expect(heroesCubit.state.heroes, equals(heroes));
        });
      });

      test('should filter heroes based on search query', () async {
        // Arrange
        final heroes = [testHero1, testHero2, testHero3];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        fakeAsync((async) {
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          heroesCubit.searchHero('Test');

          // Assert
          expect(heroesCubit.searchQuery, equals('Test'));
          expect(heroesCubit.state.heroes.length, equals(2));
          expect(heroesCubit.state.heroes, contains(testHero1));
          expect(heroesCubit.state.heroes, contains(testHero2));
        });
      });

      test('should perform case-insensitive search', () async {
        // Arrange
        final heroes = [testHero1, testHero2, testHero3];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        fakeAsync((async) {
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          heroesCubit.searchHero('TEST');

          // Assert
          expect(heroesCubit.searchQuery, equals('TEST'));
          expect(heroesCubit.state.heroes.length, equals(2));
          expect(heroesCubit.state.heroes, contains(testHero1));
          expect(heroesCubit.state.heroes, contains(testHero2));
        });
      });

      test('should handle partial matches', () async {
        // Arrange
        final heroes = [testHero1, testHero2, testHero3];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        fakeAsync((async) {
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          heroesCubit.searchHero('Another');

          // Assert
          expect(heroesCubit.searchQuery, equals('Another'));
          expect(heroesCubit.state.heroes.length, equals(1));
          expect(heroesCubit.state.heroes, contains(testHero3));
        });
      });

      test('should return empty results when no matches found', () async {
        // Arrange
        final heroes = [testHero1, testHero2, testHero3];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        fakeAsync((async) {
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          heroesCubit.searchHero('NonExistent');

          // Assert
          expect(heroesCubit.searchQuery, equals('NonExistent'));
          expect(heroesCubit.state.heroes, isEmpty);
        });
      });

      test('should handle heroes with null names safely', () async {
        // Arrange
        final heroes = [testHero1, testHeroWithNullName, testHero3];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        fakeAsync((async) {
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          heroesCubit.searchHero('Test');

          // Assert
          expect(heroesCubit.searchQuery, equals('Test'));
          expect(heroesCubit.state.heroes.length, equals(1));
          expect(heroesCubit.state.heroes, contains(testHero1));
          expect(
            heroesCubit.state.heroes,
            isNot(contains(testHeroWithNullName)),
          );
        });
      });

      test(
        'should update search query and filter results after initial load',
        () async {
          // Arrange
          final heroes = [testHero1, testHero2, testHero3];
          when(
            mockDotagiftxRemoteConfig.getHeroes(),
          ).thenAnswer((_) async => heroes);

          fakeAsync((async) {
            final heroesCubit = createUnitToTest();

            async.elapse(Duration.zero);

            // Act & Assert - First search
            heroesCubit.searchHero('Test');
            expect(heroesCubit.searchQuery, equals('Test'));
            expect(heroesCubit.state.heroes.length, equals(2));

            // Act & Assert - Second search
            heroesCubit.searchHero('Another');
            expect(heroesCubit.searchQuery, equals('Another'));
            expect(heroesCubit.state.heroes.length, equals(1));

            // Act & Assert - Clear search
            heroesCubit.searchHero('');
            expect(heroesCubit.searchQuery, isEmpty);
            expect(heroesCubit.state.heroes.length, equals(3));
          });
        },
      );
    });

    group('complex scenarios', () {
      test('should maintain search results after refresh', () async {
        // Arrange
        final heroes = [testHero1, testHero2, testHero3];
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => heroes);

        fakeAsync((async) {
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          heroesCubit.searchHero('Test');
          expect(heroesCubit.state.heroes.length, equals(2));

          heroesCubit.onSwipeToRefresh();

          async.elapse(Duration.zero);

          // Assert
          expect(heroesCubit.searchQuery, equals('Test'));
          expect(heroesCubit.state.heroes.length, equals(2));
        });
      });

      test('should handle empty hero list', () async {
        // Arrange
        when(
          mockDotagiftxRemoteConfig.getHeroes(),
        ).thenAnswer((_) async => <HeroModel>[]);

        fakeAsync((async) {
          final heroesCubit = createUnitToTest();

          async.elapse(Duration.zero);

          // Act
          heroesCubit.searchHero('Test');

          // Assert
          expect(heroesCubit.state.heroes, isEmpty);
          expect(heroesCubit.searchQuery, equals('Test'));
        });
      });
    });
  });
}
