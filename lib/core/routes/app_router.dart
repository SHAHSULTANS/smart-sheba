import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/auth/pages/otp_verification_page.dart';
import '../../presentation/splash/splash_page.dart';
import '../../presentation/main/main_page.dart';
import '../../presentation/home/home_page.dart';
import '../../presentation/services/services_page.dart';
import '../../presentation/bookings/bookings_page.dart';
import '../../presentation/profile/profile_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final phoneNumber = state.extra as String?;
          return OtpVerificationPage(phoneNumber: phoneNumber ?? '');
        },
      ),
      
      // Main Shell Route with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (context, state) => const ServicesPage(),
          ),
          GoRoute(
            path: '/bookings',
            name: 'bookings',
            builder: (context, state) => const BookingsPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
    
    // Route Redirect Logic
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/otp-verification');
      
      // If on splash, don't redirect
      if (state.matchedLocation == '/splash') {
        return null;
      }
      
      // If not authenticated and not on auth route, redirect to login
      if (authState is AuthUnauthenticated && !isAuthRoute) {
        return '/login';
      }
      
      // If authenticated and on auth route, redirect to home
      if (authState is AuthAuthenticated && isAuthRoute) {
        return '/';
      }
      
      return null;
    },
  );
}
