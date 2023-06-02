import 'package:love_and_care/infrastructure/auth/user_data_provider.dart';
import 'package:love_and_care/infrastructure/auth/user_repository.dart';

import '../../domain/auth/user_model.dart';
import '../response.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataProvider userDataSource;

  UserRepositoryImpl(this.userDataSource);

  @override
  Future<Response<User>> registerUser(
      String username, String email, String password, String role) async {
    return await userDataSource.registerUser(username, email, password, role);
  }

  @override
  Future<Response<User?>> loginUser(String email, String password) async {
    return await userDataSource.loginUser(email, password);
  }

  @override
  Future<Response<String>> logoutUser() async {
    return await userDataSource.logoutUser();
  }

  @override
  Future<Response<User?>> getLoggedInUser() async {
    return await userDataSource.getLoggedInUser();
  }

  @override
  Future<Response<User?>> updateUser(User user) async {
    return await userDataSource.updateUser(user);
  }

  @override
  Future<Response<User?>> getUser(String username) async {
    return await userDataSource.getUser(username);
  }
}
