// Step 1: Define events
import '../../domain/auth/user_model.dart';

abstract class UserEvent {}

class RegisterUserEvent extends UserEvent {
  final String email;
  final String username;
  final String password;
  final String role;

  RegisterUserEvent(this.username, this.email, this.password, this.role);
}

class UpdateUserEvent extends UserEvent {
  final User user;
  UpdateUserEvent(this.user);
}

class LoginUserEvent extends UserEvent {
  final String email;
  final String password;

  LoginUserEvent(this.email, this.password);
}

class GetUserEvent extends UserEvent {
  final String username;
  GetUserEvent(this.username);
}

class LogoutUserEvent extends UserEvent {}

class GetLoggedUserEvent extends UserEvent {}
