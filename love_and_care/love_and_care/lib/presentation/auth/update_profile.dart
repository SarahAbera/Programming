import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:love_and_care/infrastructure/auth/user_data_provider.dart';
import 'package:love_and_care/infrastructure/auth/user_repository_impl.dart';
import 'package:love_and_care/presentation/auth/input_field.dart';

import '../../application/auth/auth_bloc.dart';
import '../../application/auth/auth_bloc_event.dart';
import '../../application/auth/auth_bloc_state.dart';
import '../../domain/auth/user_model.dart';
import '../common/custom_appbar.dart';
import '../opportunity/input_fields/description_text_field.dart';
import '../opportunity/input_fields/title_text_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _aboutController = TextEditingController();
  final _skillsController = TextEditingController();
  final _interestsController = TextEditingController();
  final _addressController = TextEditingController();

  late UserBloc _userBloc;
  User? _user;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(GetLoggedUserEvent());

    // Redirect to splash screen if there is no logged-in user
    _userBloc.stream.listen((state) {
      if (state is UserSuccess) {
        _user = state.user;
        _phoneController.text = _user!.phoneNumber;
        _aboutController.text = _user!.about;
        _skillsController.text = _user!.skills;
        _interestsController.text = _user!.interests;
        _addressController.text = _user!.address;
      } else if (state is UserFailure) {
        GoRouter.of(context).push('/splash');
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _aboutController.dispose();
    _skillsController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        appBarText: "Update Profile",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User profile update success")),
              );
              Future.delayed(const Duration(seconds: 1), () {
                GoRouter.of(context).push("/user/${_user!.username}");
              });
            } else if (state is UserFailure) {
              // Show an error message.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserFailure) {
              return Center(
                  child: Column(
                children: [
                  Text(state.errorMessage),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    child: const Text("Go back home"),
                    onPressed: () {
                      GoRouter.of(context).push("/");
                    },
                  ),
                ],
              ));
            }
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    InputTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                    ),
                    const SizedBox(height: 16),
                    InputTextField(
                      controller: _addressController,
                      label: "Address",
                    ),
                    const SizedBox(height: 16),
                    InputTextField(
                      controller: _aboutController,
                      label: "About",
                    ),
                    const SizedBox(height: 16),
                    InputTextField(
                      controller: _skillsController,
                      label: "Skills",
                    ),
                    const SizedBox(height: 16),
                    InputTextField(
                      controller: _interestsController,
                      label: "Interests",
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final phone = _phoneController.text;
                          final about = _aboutController.text;
                          final skills = _skillsController.text;
                          final intersets = _interestsController.text;
                          final address = _addressController.text;

                          final userBloc = BlocProvider.of<UserBloc>(context);

                          User updatedUser = User(
                            userId: _user!.userId,
                            phoneNumber: phone,
                            about: about,
                            skills: skills,
                            address: address,
                            interests: intersets,
                            token: _user!.token,
                            email: _user!.email,
                            role: _user!.email,
                            username: _user!.username,
                          );
                          userBloc.add(UpdateUserEvent(updatedUser));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFB73E3E),
                        padding: const EdgeInsets.only(
                          left: 48,
                          right: 64,
                          top: 16,
                          bottom: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
