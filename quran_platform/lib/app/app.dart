import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/injection.dart';
import '../domain/usecases/auth_usecases.dart';
import '../domain/usecases/booking_usecases.dart';
import '../domain/usecases/prayer_usecases.dart';
import '../domain/usecases/review_usecases.dart';
import '../domain/usecases/teacher_usecases.dart';
import '../domain/usecases/user_usecases.dart';
import '../presentation/admin/bloc/admin_bloc.dart';
import '../presentation/student/bloc/auth_bloc.dart';
import '../presentation/student/bloc/booking_bloc.dart';
import '../presentation/student/bloc/home_bloc.dart';
import '../presentation/teacher/bloc/teacher_dashboard_bloc.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class QuranPlatformApp extends StatefulWidget {
  const QuranPlatformApp({super.key});

  @override
  State<QuranPlatformApp> createState() => _QuranPlatformAppState();
}

class _QuranPlatformAppState extends State<QuranPlatformApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(const AuthCheckRequested());
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => sl<HomeBloc>()),
        BlocProvider(create: (_) => sl<BookingBloc>()),
        BlocProvider(create: (_) => sl<TeacherDashboardBloc>()),
        BlocProvider(create: (_) => sl<AdminBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Центр заучивания Корана',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
