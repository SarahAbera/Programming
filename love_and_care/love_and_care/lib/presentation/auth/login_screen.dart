import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/infrastructure/infrastucture.dart';
import 'package:love_and_care/presentation/presentation.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                // Show the login form.
                return Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 32),
                          Text(
                            'Love and Care',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Volunteer/Volunteer Seeker',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Sign in to your account',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 32),
                          EmailField(controller: _emailController),
                          SizedBox(height: 16),
                          PasswordField(controller: _passwordController),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text;
                                final password = _passwordController.text;

                                final userBloc =
                                    BlocProvider.of<UserBloc>(context);
                                userBloc.add(LoginUserEvent(email, password));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFB73E3E),
                              padding: EdgeInsets.symmetric(
                                horizontal: 64,
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle "Sign Up" button press
                                  // Navigate to the sign-up screen using go_router
                                  GoRouter.of(context).push('/splash');
                                },
                                child: Text(
                                  'Sign Up',
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
