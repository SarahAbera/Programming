import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/infrastructure/infrastucture.dart';
import 'package:love_and_care/presentation/presentation.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({Key? key, required this.role}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(UserRepositoryImpl(UserDataProvider())),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserSuccess) {
                // Navigate to the home page.
                GoRouter.of(context).push('/');
              } else if (state is UserFailure) {
                // Show an error message.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state is UserLoading) {
                // Show a loading indicator.
                return Center(child: CircularProgressIndicator());
              } else {
                // Show the sign-up form.
                return Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 48),
                          Text(
                            'Love and Care',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Volunteer/Volunteer seeker',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Create an account',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 32),
                          UsernameField(controller: _usernameController),
                          SizedBox(height: 16),
                          EmailField(controller: _emailController),
                          SizedBox(height: 16),
                          PasswordField(controller: _passwordController),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text;
                                final password = _passwordController.text;
                                final username = _usernameController.text;
                                final userBloc =
                                    BlocProvider.of<UserBloc>(context);
                                userBloc.add(
                                  RegisterUserEvent(
                                      username, email, password, widget.role),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFB73E3E),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 64, vertical: 16),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle "Sign In" button press
                                  // Navigate to the login screen using go_router
                                  GoRouter.of(context).push('/login');
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB73E3E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
