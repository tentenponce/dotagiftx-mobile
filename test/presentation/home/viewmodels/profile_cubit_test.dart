import 'dart:async';

import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/local/listen_local_storage.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/login_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/logout_usecase.dart';
import 'package:dotagiftx_mobile/presentation/home/states/profile_state.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/profile_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Logger>(),
  MockSpec<EnvironmentVariables>(),
  MockSpec<LoginUsecase>(),
  MockSpec<LogoutUsecase>(),
  MockSpec<ListenLocalStorage>(),
])
void main() {
  group(ProfileCubit, () {
    late MockLogger mockLogger;
    late MockEnvironmentVariables mockEnvironmentVariables;
    late MockLoginUsecase mockLoginUsecase;
    late MockLogoutUsecase mockLogoutUsecase;
    late MockListenLocalStorage mockListenLocalStorage;
    late bool navigateToHomeCalled;

    // Test data
    const testBaseUrl = 'https://api.example.com';
    const testOpenId = 'test-openid-12345';
    const testUserModel = UserModel(
      name: 'Test User',
      url: 'https://steamcommunity.com/profiles/12345',
      avatar: 'https://example.com/avatar.png',
      createdAt: '2024-01-01T00:00:00Z',
      marketStats: MarketStats(live: 5, reserved: 2, sold: 10, bidCompleted: 3),
      subscription: 1,
      subscribedAt: '2024-01-01T00:00:00Z',
    );

    setUp(() {
      mockLogger = MockLogger();
      mockEnvironmentVariables = MockEnvironmentVariables();
      mockLoginUsecase = MockLoginUsecase();
      mockLogoutUsecase = MockLogoutUsecase();
      mockListenLocalStorage = MockListenLocalStorage();
      navigateToHomeCalled = false;

      when(mockEnvironmentVariables.baseUrl).thenReturn(testBaseUrl);
    });

    ProfileCubit createUnitToTest() {
      final cubit = ProfileCubit(
        mockLogger,
        mockEnvironmentVariables,
        mockLoginUsecase,
        mockLogoutUsecase,
        mockListenLocalStorage,
      );
      cubit.navigateToHome = () {
        navigateToHomeCalled = true;
      };
      return cubit;
    }

    group('getLoginUrl', () {
      test('should return correct login URL', () {
        // Arrange
        final profileCubit = createUnitToTest();

        // Act
        final result = profileCubit.getLoginUrl();

        // Assert
        expect(result, equals('$testBaseUrl${ApiConstants.loginUrl}'));
        verify(mockEnvironmentVariables.baseUrl).called(1);
      });
    });

    group('init', () {
      test('should listen to user changes', () async {
        // Arrange
        final userController = StreamController<UserModel?>();
        when(
          mockListenLocalStorage.listenUser(),
        ).thenAnswer((_) => userController.stream);

        // Act
        final profileCubit = createUnitToTest();

        // Emit test user
        userController.add(testUserModel);
        await Future<void>.delayed(Duration.zero); // Let stream process

        // Assert
        verify(mockListenLocalStorage.listenUser()).called(1);
        expect(profileCubit.state.user, equals(testUserModel));

        // Cleanup
        await userController.close();
      });

      test('should handle null user from stream', () async {
        // Arrange
        final userController = StreamController<UserModel?>();
        when(
          mockListenLocalStorage.listenUser(),
        ).thenAnswer((_) => userController.stream);

        // Act
        final profileCubit = createUnitToTest();

        // Emit null user
        userController.add(null);
        await Future<void>.delayed(Duration.zero); // Let stream process

        // Assert
        expect(profileCubit.state.user, isNull);

        // Cleanup
        await userController.close();
      });
    });

    group('login', () {
      test('should complete login successfully', () async {
        // Arrange
        when(
          mockLoginUsecase.call(testOpenId),
        ).thenAnswer((_) async => testUserModel);
        when(
          mockListenLocalStorage.listenUser(),
        ).thenAnswer((_) => const Stream.empty());

        final profileCubit = createUnitToTest();

        // Act
        await profileCubit.login(testOpenId);

        // Assert
        expect(profileCubit.state.user, equals(testUserModel));
        expect(profileCubit.state.loadingLogin, isFalse);
        expect(navigateToHomeCalled, isTrue);
        verify(mockLoginUsecase.call(testOpenId)).called(1);
      });

      test('should handle login failure', () async {
        // Arrange
        when(
          mockLoginUsecase.call(testOpenId),
        ).thenThrow(Exception('Login failed'));
        when(
          mockListenLocalStorage.listenUser(),
        ).thenAnswer((_) => const Stream.empty());

        final profileCubit = createUnitToTest();

        // Act
        await profileCubit.login(testOpenId);

        // Assert
        expect(profileCubit.state.user, isNull);
        expect(profileCubit.state.loadingLogin, isFalse);
        expect(navigateToHomeCalled, isFalse);
        verify(mockLoginUsecase.call(testOpenId)).called(1);
      });

      test('should set loading state during login', () async {
        // Arrange
        final completer = Completer<UserModel>();
        when(
          mockLoginUsecase.call(testOpenId),
        ).thenAnswer((_) => completer.future);
        when(
          mockListenLocalStorage.listenUser(),
        ).thenAnswer((_) => const Stream.empty());

        final profileCubit = createUnitToTest();

        // Act
        final loginFuture = profileCubit.login(testOpenId);

        // Assert loading state
        expect(profileCubit.state.loadingLogin, isTrue);

        // Complete the login
        completer.complete(testUserModel);
        await loginFuture;

        // Assert final state
        expect(profileCubit.state.loadingLogin, isFalse);
      });
    });

    group('logout', () {
      test('should complete logout successfully', () async {
        // Arrange
        when(mockLogoutUsecase.call()).thenAnswer((_) async {
          return;
        });
        when(
          mockListenLocalStorage.listenUser(),
        ).thenAnswer((_) => const Stream.empty());

        final profileCubit = createUnitToTest();
        // Set initial user state
        profileCubit.emit(profileCubit.state.copyWith(user: testUserModel));

        // Act
        await profileCubit.logout();

        // Assert
        expect(profileCubit.state.user, isNull);
        expect(profileCubit.state.loadingLogout, isFalse);
        expect(navigateToHomeCalled, isTrue);
        verify(mockLogoutUsecase.call()).called(1);
      });

      test('should handle logout failure', () async {
        // Arrange
        when(mockLogoutUsecase.call()).thenThrow(Exception('Logout failed'));
        when(
          mockListenLocalStorage.listenUser(),
        ).thenAnswer((_) => const Stream.empty());

        final profileCubit = createUnitToTest();
        // Set initial user state
        profileCubit.emit(profileCubit.state.copyWith(user: testUserModel));

        // Act
        await profileCubit.logout();

        // Assert
        expect(
          profileCubit.state.user,
          equals(testUserModel),
        ); // Should remain unchanged
        expect(profileCubit.state.loadingLogout, isFalse);
        expect(navigateToHomeCalled, isFalse);
        verify(mockLogoutUsecase.call()).called(1);
      });

      test('should set loading state during logout', () async {
        // Arrange
        final completer = Completer<void>();
        when(mockLogoutUsecase.call()).thenAnswer((_) => completer.future);
        when(
          mockListenLocalStorage.listenUser(),
        ).thenAnswer((_) => const Stream.empty());

        final profileCubit = createUnitToTest();

        // Act
        final logoutFuture = profileCubit.logout();

        // Assert loading state
        expect(profileCubit.state.loadingLogout, isTrue);

        // Complete the logout
        completer.complete();
        await logoutFuture;

        // Assert final state
        expect(profileCubit.state.loadingLogout, isFalse);
      });
    });

    group('state management', () {
      test('should have correct initial state', () {
        // Arrange & Act
        final profileCubit = createUnitToTest();

        // Assert
        expect(profileCubit.state, equals(const ProfileState()));
        expect(profileCubit.state.user, isNull);
        expect(profileCubit.state.loadingLogin, isFalse);
        expect(profileCubit.state.loadingLogout, isFalse);
      });
    });
  });
}
