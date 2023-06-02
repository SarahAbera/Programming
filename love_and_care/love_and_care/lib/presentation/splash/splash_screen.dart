import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Love and Care Volunteer Connector',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Image.asset(
                'assets/images/splash.png',
                width: 200,
                height: 200,
                // Adjust the image properties as needed
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle account checking button press
                  // Navigate to the appropriate screen for account checking using go_router
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFB73E3E),
                ),
                child: Text('Login'),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Or signup as:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle volunteer button press
                      // Navigate to the login screen for volunteer using go_router
                      context.go('/register/Volunteer');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFB73E3E),
                    ),
                    child: Text('Volunteer'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle volunteer seeker button press
                      // Navigate to the login screen for volunteer seeker using go_router
                      context.go('/register/Volunteer Seeker');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFB73E3E),
                    ),
                    child: Text('Volunteer Seeker'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
