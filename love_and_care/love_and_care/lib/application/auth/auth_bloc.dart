// Step 3 and 4: Create the BLoC class
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../infrastructure/auth/user_repository.dart';
import 'auth_bloc_event.dart';
import 'auth_bloc_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<LoginUserEvent>(_onLoginUser);
    on<LogoutUserEvent>(_onLogoutUser);
    on<GetLoggedUserEvent>(_onGetLoggedUserEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<GetUserEvent>(_onGetUserEvent);
  }

  void _onRegisterUser(RegisterUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    var response = await userRepository.registerUser(
        event.username, event.email, event.password, event.role);
    if (response.data != null) {
      emit(UserSuccess(response.data!, null));
    } else {
      emit(UserFailure(response.error!));
    }
  }

  void _onUpdateUserEvent(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    var response = await userRepository.updateUser(event.user);
    if (response.data != null) {
      emit(UserUpdateSuccess());
      emit(UserSuccess(response.data!, null));
    } else {
      emit(UserFailure(response.error!));
    }
  }

  void _onGetUserEvent(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    var user = await userRepository.getUser(event.username);
    var profile = await userRepository.getLoggedInUser();

    if (user.data != null && profile.data != null) {
      emit(UserSuccess(user.data!, profile.data!));
    } else {
      emit(UserFailure(user.error!));
    }
  }

  Future<void> _onLoginUser(
      LoginUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    var response = await userRepository.loginUser(event.email, event.password);
    if (response.data != null) {
      emit(UserSuccess(response.data!, null));
    } else {
      emit(UserFailure(response.error!));
    }
  }

  Future<void> _onLogoutUser(
      LogoutUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    var response = await userRepository.logoutUser();
    if (response.data != null) {
      emit(UserLogoutSuccess());
    } else {
      emit(UserFailure(response.error!));
    }
  }

  Future<void> _onGetLoggedUserEvent(
      GetLoggedUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    var response = await userRepository.getLoggedInUser();
    if (response.data != null) {
      emit(UserSuccess(response.data!, null));
    } else {
      emit(UserFailure(response.error!));
    }
  }
}
