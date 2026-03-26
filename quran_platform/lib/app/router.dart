import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../domain/entities/booking_entity.dart';
import '../presentation/admin/screens/admin_login_screen.dart';
import '../presentation/admin/screens/admin_shell.dart';
import '../presentation/admin/screens/admin_teacher_edit_screen.dart';
import '../presentation/student/bloc/auth_bloc.dart';
import '../presentation/student/screens/auth_screen.dart';
import '../presentation/student/screens/booking_confirmation_screen.dart';
import '../presentation/student/screens/booking_screen.dart';
import '../presentation/student/screens/chat_screen.dart';
import '../presentation/student/screens/lesson_detail_screen.dart';
import '../presentation/student/screens/onboarding_screen.dart';
import '../presentation/student/screens/settings_screen.dart';
import '../presentation/student/screens/splash_screen.dart';
import '../presentation/student/screens/student_shell.dart';
import '../presentation/student/screens/support_chat_screen.dart';
import '../presentation/student/screens/teacher_profile_screen.dart';
import '../presentation/teacher/screens/teacher_login_screen.dart';
import '../presentation/teacher/screens/teacher_shell.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuth = authState is AuthAuthenticated;
      final isOnAuthPage = state.matchedLocation == '/auth' ||
          state.matchedLocation == '/onboarding' ||
          state.matchedLocation == '/teacher-login' ||
          state.matchedLocation == '/admin-login' ||
          state.matchedLocation == '/';

      if (!isAuth && !isOnAuthPage) {
        return '/auth';
      }

      if (isAuth && isOnAuthPage) {
        final role = (authState as AuthAuthenticated).user.role;
        switch (role) {
          case AppConstants.roleAdmin:
            return '/admin';
          case AppConstants.roleTeacher:
            return '/teacher';
          default:
            return '/student';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (_, __) => const AuthScreen(),
      ),
      GoRoute(
        path: '/teacher-login',
        builder: (_, __) => const TeacherLoginScreen(),
      ),
      GoRoute(
        path: '/admin-login',
        builder: (_, __) => const AdminLoginScreen(),
      ),

      // ─── Student ───
      GoRoute(
        path: '/student',
        builder: (_, __) => const StudentShell(),
        routes: [
          GoRoute(
            path: 'teacher/:id',
            builder: (_, state) => TeacherProfileScreen(
              teacherId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: 'booking/:teacherId/:teacherName',
            builder: (_, state) => BookingScreen(
              teacherId: state.pathParameters['teacherId']!,
              teacherName: Uri.decodeComponent(
                  state.pathParameters['teacherName']!),
            ),
          ),
          GoRoute(
            path: 'booking-confirmation',
            builder: (_, __) => const BookingConfirmationScreen(),
          ),
          GoRoute(
            path: 'lesson/:id',
            builder: (_, state) {
              final booking = state.extra as BookingEntity?;
              if (booking == null) {
                return const Scaffold(
                  body: Center(child: Text('Урок не найден')),
                );
              }
              return LessonDetailScreen(booking: booking);
            },
          ),
          GoRoute(
            path: 'chat/:name/:id',
            builder: (_, state) => ChatScreen(
              recipientName: Uri.decodeComponent(
                  state.pathParameters['name']!),
              recipientId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: 'support',
            builder: (_, __) => const SupportChatScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),

      // ─── Teacher ───
      GoRoute(
        path: '/teacher',
        builder: (_, __) => const TeacherShell(),
      ),

      // ─── Admin ───
      GoRoute(
        path: '/admin',
        builder: (_, __) => const AdminShell(),
        routes: [
          GoRoute(
            path: 'teacher/:id',
            builder: (_, state) => AdminTeacherEditScreen(
              teacherId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
    ],
  );
}
