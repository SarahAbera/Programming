import 'package:flutter_test/flutter_test.dart';
import 'package:love_and_care/infrastructure/auth/user_repository_impl.dart';
import 'package:love_and_care/infrastructure/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:love_and_care/domain/auth/user_model.dart';
import 'package:love_and_care/infrastructure/auth/user_data_provider.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([
  UserDataProvider,
])
void main() {
  late UserRepositoryImpl repository;
  late MockUserDataProvider mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockUserDataProvider();
    repository = UserRepositoryImpl(
      mockRemoteDataSource,
    );
  });
  final username = 'testuser';
  final email = 'test@example.com';
  final password = 'testpassword';
  final role = 'user';
  final userId = "1";
  final token = "1";

  final phoneNumber = 'testuser';
  final skills = 'test@example.com';
  final interests = 'testpassword';
  final address = 'user';
  final about = 'about';

  final user = User(
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
  final response = Response<User>.success(user);

  group('User Repository', () {
    group("Register User", () {
      test('registerUser should return success response', () async {
        // Arrange
        when(mockRemoteDataSource.registerUser(username, email, password, role))
            .thenAnswer((_) async => response);

        // Act
        final result =
            await repository.registerUser(username, email, password, role);

        // Assert
        expect(result.data, response.data);
        verify(
            mockRemoteDataSource.registerUser(username, email, password, role));
      });
      test('registerUser should return error response', () async {
        // Arrange
        final errorMessage = 'Registration failed';
        final errorResponse = Response<User>.error(errorMessage);

        when(mockRemoteDataSource.registerUser(username, email, password, role))
            .thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.registerUser(
          username,
          email,
          password,
          role,
        );

        // Assert
        expect(result.error, errorMessage);
        verify(
            mockRemoteDataSource.registerUser(username, email, password, role));
      });
    });

    group("Login User", () {
      test('loginUser should return success response', () async {
        // Arrange
        when(mockRemoteDataSource.loginUser(email, password))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.loginUser(email, password);

        // Assert
        expect(result.data, response.data);
        verify(mockRemoteDataSource.loginUser(email, password));
      });
      test('login should return error response', () async {
        // Arrange
        final errorMessage = 'login failed';
        final errorResponse = Response<User>.error(errorMessage);

        when(mockRemoteDataSource.loginUser(email, password))
            .thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.loginUser(email, password);
        // Assert
        expect(result.error, errorMessage);
        verify(mockRemoteDataSource.loginUser(email, password));
      });
    });

    group("Logout User", () {
      test('logout should return success message string', () async {
        // Arrange
        var logoutResponse = Response.success("log out success");
        when(mockRemoteDataSource.logoutUser())
            .thenAnswer((_) async => logoutResponse);

        // Act
        final result = await repository.logoutUser();

        // Assert
        expect(result.data, logoutResponse.data);
        verify(mockRemoteDataSource.logoutUser());
      });
      test('logout should return error response', () async {
        // Arrange
        final errorMessage = 'login failed';
        final errorResponse = Response<String>.error(errorMessage);

        when(mockRemoteDataSource.logoutUser())
            .thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.logoutUser();
        // Assert
        expect(result.error, errorMessage);
        verify(mockRemoteDataSource.logoutUser());
      });
    });
  });
}
