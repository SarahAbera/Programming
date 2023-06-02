// Step 2: Define states
import 'package:equatable/equatable.dart';

import '../../domain/auth/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLogoutSuccess extends UserState {}

class UserUpdateSuccess extends UserState {}


class UserSuccess extends UserState {
  final User user;
  final User? profile;

  UserSuccess(this.user, this.profile);
}

class GetUserSuccess extends UserState {
  final User user;

  GetUserSuccess(this.user);
}

class UserFailure extends UserState {
  final String errorMessage;

  UserFailure(this.errorMessage);
}
