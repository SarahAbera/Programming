import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:love_and_care/application/auth/auth_bloc.dart';
import 'package:love_and_care/application/auth/auth_bloc_event.dart';
import 'package:love_and_care/application/auth/auth_bloc_state.dart';
import 'package:love_and_care/domain/auth/user_model.dart';
import 'package:love_and_care/infrastructure/auth/user_repository.dart';
import 'package:love_and_care/infrastructure/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_bloc_test.mocks.dart';

@GenerateMocks([
  UserRepository,
])
void main() {
  late UserBloc userBloc;
  late MockUserRepository mockUserRepository;

  final username = 'testuser';
  final email = 'test@example.com';
  final password = 'testpassword';
  final role = 'user';
  final userId = '1';
  final token = 'token';

  final phoneNumber = 'testuser';
  final skills = 'test@example.com';
  final interests = 'testpassword';
  final address = 'user';
  final about = 'about';

  final testUser = User(
      userId: userId,
      username: username,
      email: email,
      role: role,
      token: token,
      phoneNumber: phoneNumber,
      address: address,
      interests: interests,
      about: about,
      skills: skills);

  setUp(() {
    mockUserRepository = MockUserRepository();
    userBloc = UserBloc(mockUserRepository);
  });

  tearDown(() {
    userBloc.close();
  });

  group('UserBloc', () {
    test('initial state is UserInitial', () {
      // Arrange
      userBloc = UserBloc(mockUserRepository);

      // Assert
      expect(userBloc.state, equals(UserInitial()));
    });
    test(
      'emits [UserLoading, UserSuccess] when RegisterUserEvent is added and registration succeeds',
      () async {
        // Arrange
        final registerEvent = RegisterUserEvent(
          username,
          email,
          password,
          role,
        );
        final successResponse = Response<User>.success(testUser);

        when(mockUserRepository.registerUser(username, email, password, role))
            .thenAnswer((_) async => successResponse);

        // Act
        userBloc.add(registerEvent);

        // Assert
        await expectLater(
          userBloc.stream,
          emitsInOrder([UserLoading(), UserSuccess(testUser, null)]),
        );
      },
    );

    test(
      'emits [UserLoading, UserFailure] when RegisterUserEvent is added and registration fails',
      () async {
        // Arrange
        final registerEvent = RegisterUserEvent(
          username,
          email,
          password,
          role,
        );
        final failureResponse = Response<User>.error('Registration failed');

        when(mockUserRepository.registerUser(username, email, password, role))
            .thenAnswer((_) async => failureResponse);

        // Act
        userBloc.add(registerEvent);

        // Assert
        await expectLater(
          userBloc.stream,
          emitsInOrder([UserLoading(), UserFailure('Registration failed')]),
        );
      },
    );

    test(
      'emits [UserLoading, UserSuccess] when LoginUserEvent is added and login succeeds',
      () async {
        // Arrange
        final loginEvent = LoginUserEvent(email, password);
        final successResponse = Response<User>.success(testUser);

        when(mockUserRepository.loginUser(email, password))
            .thenAnswer((_) async => successResponse);

        // Act
        userBloc.add(loginEvent);

        // Assert
        await expectLater(
          userBloc.stream,
          emitsInOrder([UserLoading(), UserSuccess(testUser, null)]),
        );
      },
    );

    test(
      'emits [UserLoading, UserFailure] when LoginUserEvent is added and login fails',
      () async {
        // Arrange
        final loginEvent = LoginUserEvent(email, password);
        final failureResponse = Response<User>.error('Login failed');

        when(mockUserRepository.loginUser(email, password))
            .thenAnswer((_) async => failureResponse);

        // Act
        userBloc.add(loginEvent);

        // Assert
        await expectLater(
          userBloc.stream,
          emitsInOrder([UserLoading(), UserFailure('Login failed')]),
        );
      },
    );

    test(
      'emits [UserLoading, UserLogoutSuccess] when LogoutUserEvent is added and logout succeeds',
      () async {
        // Arrange
        final logoutEvent = LogoutUserEvent();

        final successResponse = Response<String>.success('success');

        when(mockUserRepository.logoutUser())
            .thenAnswer((_) async => successResponse);

        // Act
        userBloc.add(logoutEvent);

        // Assert
        await expectLater(
          userBloc.stream,
          emitsInOrder([UserLoading(), UserLogoutSuccess()]),
        );
      },
    );

    test(
      'emits [UserLoading, UserFailure] when LogoutUserEvent is added and logout fails',
      () async {
        // Arrange
        final logoutEvent = LogoutUserEvent();
        final failureResponse = Response<String>.error('Logout failed');

        when(mockUserRepository.logoutUser())
            .thenAnswer((_) async => failureResponse);

        // Act
        userBloc.add(logoutEvent);

        // Assert
        await expectLater(
          userBloc.stream,
          emitsInOrder([UserLoading(), UserFailure('Logout failed')]),
        );
      },
    );

    test(
      'emits [UserLoading, UserSuccess] when GetLoggedUserEvent is added and retrieval succeeds',
      () async {
        // Arrange
        final getLoggedUserEvent = GetLoggedUserEvent();
        final successResponse = Response<User>.success(testUser);

        when(mockUserRepository.getLoggedInUser())
            .thenAnswer((_) async => successResponse);

        // Act
        userBloc.add(getLoggedUserEvent);

        // Assert
        await expectLater(
          userBloc.stream,
          emitsInOrder([UserLoading(), UserSuccess(testUser, null)]),
        );
      },
    );

    test(
      'emits [UserLoading, UserFailure] when GetLoggedUserEvent is added and retrieval fails',
      () async {
        // Arrange
        final getLoggedUserEvent = GetLoggedUserEvent();
        final failureResponse = Response<User>.error('User retrieval failed');

        when(mockUserRepository.getLoggedInUser())
            .thenAnswer((_) async => failureResponse);

        // Act
        userBloc.add(getLoggedUserEvent);

        // Assert
        await expectLater(
          userBloc.stream,
          emitsInOrder([UserLoading(), UserFailure('User retrieval failed')]),
        );
      },
    );
  });
}
