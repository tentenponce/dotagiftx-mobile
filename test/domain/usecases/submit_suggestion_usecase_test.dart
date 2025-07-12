import 'dart:async';

import 'package:dotagiftx_mobile/data/platform/dotagiftx_storage.dart';
import 'package:dotagiftx_mobile/domain/usecases/submit_suggestion_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'submit_suggestion_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DotagiftxStorage>()])
void main() {
  group(SubmitSuggestionUsecaseImpl, () {
    late MockDotagiftxStorage mockDotagiftxStorage;
    late SubmitSuggestionUsecaseImpl usecase;

    setUp(() {
      mockDotagiftxStorage = MockDotagiftxStorage();
      usecase = SubmitSuggestionUsecaseImpl(mockDotagiftxStorage);
    });

    group('submit', () {
      test('should submit suggestion successfully', () async {
        // Arrange
        const suggestion = 'Add dark mode support';
        when(
          mockDotagiftxStorage.submitSuggestion(suggestion),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.submit(suggestion);

        // Assert
        verify(mockDotagiftxStorage.submitSuggestion(suggestion)).called(1);
      });

      test('should submit empty suggestion', () async {
        // Arrange
        const suggestion = '';
        when(
          mockDotagiftxStorage.submitSuggestion(suggestion),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.submit(suggestion);

        // Assert
        verify(mockDotagiftxStorage.submitSuggestion(suggestion)).called(1);
      });

      test('should submit suggestion with special characters', () async {
        // Arrange
        const suggestion =
            r'Add feature with @#$%^&*()_+=-[]{}|;:,.<>? characters';
        when(
          mockDotagiftxStorage.submitSuggestion(suggestion),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.submit(suggestion);

        // Assert
        verify(mockDotagiftxStorage.submitSuggestion(suggestion)).called(1);
      });

      test('should submit long suggestion', () async {
        // Arrange
        const suggestion =
            'This is a very long suggestion that contains many '
            'words and characters to test the ability to handle long text '
            'submissions without any issues or limitations in the system '
            'that could potentially cause problems or errors during the '
            'submission process.';
        when(
          mockDotagiftxStorage.submitSuggestion(suggestion),
        ).thenAnswer((_) async => {});

        // Act
        await usecase.submit(suggestion);

        // Assert
        verify(mockDotagiftxStorage.submitSuggestion(suggestion)).called(1);
      });

      test('should handle submission error', () async {
        // Arrange
        const suggestion = 'Test suggestion';
        when(
          mockDotagiftxStorage.submitSuggestion(suggestion),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => usecase.submit(suggestion), throwsException);
        verify(mockDotagiftxStorage.submitSuggestion(suggestion)).called(1);
      });

      test('should handle submission timeout', () async {
        // Arrange
        const suggestion = 'Test suggestion';
        when(mockDotagiftxStorage.submitSuggestion(suggestion)).thenThrow(
          TimeoutException('Request timeout', const Duration(seconds: 30)),
        );

        // Act & Assert
        expect(
          () => usecase.submit(suggestion),
          throwsA(isA<TimeoutException>()),
        );
        verify(mockDotagiftxStorage.submitSuggestion(suggestion)).called(1);
      });

      test('should handle submission with null storage response', () async {
        // Arrange
        const suggestion = 'Test suggestion';
        when(
          mockDotagiftxStorage.submitSuggestion(suggestion),
        ).thenAnswer((_) => Future.value());

        // Act
        await usecase.submit(suggestion);

        // Assert
        verify(mockDotagiftxStorage.submitSuggestion(suggestion)).called(1);
      });
    });
  });
}
