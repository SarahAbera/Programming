import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/auth/auth_bloc.dart';
import '../../application/auth/auth_bloc_event.dart';
import '../../application/auth/auth_bloc_state.dart';
import '../../domain/auth/user_model.dart';
import '../common/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserBloc _userBloc;
  User? _user;
  User? _profile;

  @override
  void initState() {
    super.initState();

    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(GetUserEvent(widget.username));

    _userBloc.stream.listen((state) {
      if (state is UserSuccess) {
        _user = state.user;
        _profile = state.profile;
      } else if (state is UserFailure) {
        // No logged-in user, redirect to splash screen
        GoRouter.of(context).push('/splash');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarText: "User Profile",
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserSuccess) {
            if (state.profile == null) {
              return Center(child: Text("Profile does not exit"));
            }
            final user = state.profile;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  title: const Text('Username'),
                  subtitle:
                      Text(user!.username.isNotEmpty ? user.username : 'None'),
                ),
                ListTile(
                  title: const Text('Email'),
                  subtitle: Text(user.email.isNotEmpty ? user.email : 'None'),
                ),
                ListTile(
                  title: const Text('Phone Number'),
                  subtitle: Text(
                      user.phoneNumber.isNotEmpty ? user.phoneNumber : 'None'),
                ),
                ListTile(
                  title: const Text('Address'),
                  subtitle:
                      Text(user.address.isNotEmpty ? user.address : 'None'),
                ),
                ListTile(
                  title: const Text('About'),
                  subtitle: Text(user.about.isNotEmpty ? user.about : 'None'),
                ),
                ListTile(
                  title: const Text('Interests'),
                  subtitle:
                      Text(user.interests.isNotEmpty ? user.interests : 'None'),
                ),
                ListTile(
                  title: const Text('Skills'),
                  subtitle: Text(user.skills.isNotEmpty ? user.skills : 'None'),
                ),
              ],
            );
          } else if (state is UserLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserFailure) {
            return Center(
              child: Text('Failed to load user: ${state.errorMessage}'),
            );
          } else {
            return const SizedBox(); // Placeholder or empty widget
          }
        },
      ),
      floatingActionButton: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserSuccess &&
              _profile != null &&
              _user?.username == _profile!.username) {
            return FloatingActionButton.extended(
              backgroundColor: Color(0xFFB73E3E),
              onPressed: () {
                // Perform action for adding an event
                GoRouter.of(context).push("/update-user");
              },
              icon: const Icon(
                Icons.update,
              ),
              label: const Text('Update Profile'),
              tooltip: 'Update Profile',
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
