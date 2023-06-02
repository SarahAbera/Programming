import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:love_and_care/application/auth/auth_bloc.dart';
import 'package:love_and_care/application/auth/auth_bloc_event.dart';
import 'package:love_and_care/application/auth/auth_bloc_state.dart';
import 'package:love_and_care/infrastructure/auth/user_repository.dart';
import 'package:love_and_care/presentation/auth/email_field.dart';
import 'package:love_and_care/presentation/auth/login_screen.dart';
import 'package:love_and_care/presentation/auth/password_field.dart';

void main() {
  group('LoginScreen', () {
    late UserBloc userBloc;

    setUp(() {
      // Set up the UserBloc instance for testing
      userBloc = UserBloc(MockUserRepository());
    });

    tearDown(() {
      // Clean up resources after testing
      userBloc.close();
    });

    testWidgets('renders login screen with form', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserBloc>.value(
            value: userBloc,
            child: const LoginScreen(),
          ),
        ),
      );

      // Verify that the login screen is displayed
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Love and Care'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Don\'t have an account?'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      // Enter valid email and password
      await tester.enterText(find.byType(EmailField), 'test@example.com');
      await tester.enterText(find.byType(PasswordField), 'password');

      // Tap the login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify that the userBloc received the login event
      expect(userBloc.state, isA<UserLoading>());
      expect(userBloc.state, emits(isA<UserSuccess>()));
    });
  });
}

class MockUserRepository extends Fake implements UserRepository {
  @override
  Future<void> login(
      String email, String password, BuildContext context) async {
    BlocProvider.of<UserBloc>(context).add(LoginUserEvent(email, password));
  }
}
