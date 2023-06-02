import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/application.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String appBarText;

  const CustomAppBar({super.key, required this.appBarText});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFB73E3E),
      title: Center(
        child: Text(widget.appBarText),
      ),
      actions: [
        BlocConsumer<UserBloc, UserState>(
          listener: (context, state) => {
            if (state is UserLogoutSuccess) {context.go("/splash")}
          },
          builder: (context, state) {
            if (state is UserLoading) {
              // Show a loading indicator.
              return Center(child: CircularProgressIndicator());
            }

            if (state is UserSuccess) {
              var _user = state.user; // Declare _user variable here

              return PopupMenuButton<String>(
                onSelected: (choice) {
                  if (choice == 'profile') {
                    // Show profile options
                    GoRouter.of(context).push("/user/${_user.username}");
                  } else if (choice == 'My Events') {
                    // Handle My Events choice

                    GoRouter.of(context)
                        .push("/user-opportunity/Volunteer-Seeker");
                  } else if (choice == "Participated Events") {
                    // Handle My Events choice
                    GoRouter.of(context).push("/user-opportunity/Volunteer");
                  } else if (choice == 'logout') {
                    // Perform logout
                    var userBloc = BlocProvider.of<UserBloc>(context);
                    userBloc.add(LogoutUserEvent());
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: const [
                        Icon(
                          Icons.person,
                          color: Color(0xFFB73E3E),
                        ),
                        SizedBox(width: 8),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: _user.role == "Volunteer"
                        ? "Participated Events"
                        : 'My Events',
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: Color(0xFFB73E3E),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _user.role == "Volunteer"
                              ? "Participated Events"
                              : 'My Events',
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout,
                          color: Color(0xFFB73E3E),
                        ),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(
                        _user!.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      radius: 20,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              );
            } else {
              print("user state");
              print("user state");
              print("user state");
              print("user state");
              print(state);
              print("user state");

              return IconButton(
                onPressed: () {
                  // Navigate to login/signup screen
                },
                icon: const Icon(Icons.login),
              );
            }
          },
        ),
      ],
    );
  }
}
