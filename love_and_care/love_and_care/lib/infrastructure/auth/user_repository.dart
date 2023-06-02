import '../../domain/auth/user_model.dart';
import '../response.dart';

abstract class UserRepository {
  Future<Response<User>> registerUser(
      String username, String email, String password, String role);
  Future<Response<User?>> loginUser(String email, String password);
  Future<Response<User?>> updateUser(User user);
  Future<Response<User?>> getUser(String username);

  Future<Response<String>> logoutUser();
  Future<Response<User?>> getLoggedInUser();
}
