import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:love_and_care/presentation/auth/profile_screen.dart';
import '../auth/update_profile.dart';
import '../presentation.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginScreen();
      },
    ),
    
    GoRoute(
      path: '/register/:role',
      builder: (BuildContext context, GoRouterState state) {
        final role = state.pathParameters['role']!;
        return RegisterScreen(
          role: role,
        );
      },
    ),
    GoRoute(
      path: '/opportunity/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id']!;
        return OpportunityDetail(
          id: id,
        );
      },
    ),
    GoRoute(
      path: '/update-opportunity/:id',
      builder: (BuildContext context, GoRouterState state) {
        final id = state.pathParameters['id']!;
        return UpdateOpportunityScreen(opportunityId: id);
      },
    ),
    GoRoute(
      path: '/create-opportunity',
      builder: (BuildContext context, GoRouterState state) {
        return CreateOpportunityScreen();
      },
    ),
    GoRoute(
      path: '/user-opportunity/:role',
      builder: (BuildContext context, GoRouterState state) {
        final role = state.pathParameters['role']!;
        return UserEventsScreen(role: role);
      },
    ),
    GoRoute(
      path: '/user/:username',
      builder: (BuildContext context, GoRouterState state) {
        final username = state.pathParameters['username']!;
        return ProfileScreen(username: username);
      },
    ),
    GoRoute(
      path: '/update-user',
      builder: (BuildContext context, GoRouterState state) {
        return UpdateProfileScreen();
      },
    ),
  ],
);

// /create-opportunity