import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/analytics_service.dart';
import '../services/crash_service.dart';

import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/booking_datasource.dart';
import '../../data/datasources/teacher_datasource.dart';
import '../../data/datasources/user_datasource.dart';
import '../../data/datasources/storage_datasource.dart';
import '../../data/datasources/prayer_datasource.dart';
import '../../data/datasources/review_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../data/repositories/teacher_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/storage_repository_impl.dart';
import '../../data/repositories/prayer_repository_impl.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/booking_usecases.dart';
import '../../domain/usecases/teacher_usecases.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../domain/usecases/prayer_usecases.dart';
import '../../domain/usecases/review_usecases.dart';
import '../../presentation/student/bloc/auth_bloc.dart';
import '../../presentation/student/bloc/home_bloc.dart';
import '../../presentation/student/bloc/teacher_bloc.dart';
import '../../presentation/student/bloc/booking_bloc.dart';
import '../../presentation/teacher/bloc/teacher_dashboard_bloc.dart';
import '../../presentation/admin/bloc/admin_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ─── External ───
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => FirebaseCrashlytics.instance);
  sl.registerLazySingleton(() => FirebaseAnalytics.instance);

  // ─── Services (логирование) ───
  sl.registerLazySingleton(() => CrashService(sl()));
  sl.registerLazySingleton(() => AnalyticsService(sl()));

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  // ─── Data Sources ───
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TeacherDataSource>(
    () => TeacherDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<BookingDataSource>(
    () => BookingDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<StorageDataSource>(
    () => StorageDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PrayerDataSource>(
    () => PrayerDataSourceImpl(),
  );
  sl.registerLazySingleton<ReviewDataSource>(
    () => ReviewDataSourceImpl(sl()),
  );

  // ─── Repositories ───
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TeacherRepository>(
    () => TeacherRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<StorageRepository>(
    () => StorageRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<PrayerRepository>(
    () => PrayerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(sl()),
  );

  // ─── Use Cases ───
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithPhone(sl()));
  sl.registerLazySingleton(() => VerifyPhoneCode(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));

  sl.registerLazySingleton(() => GetTeachers(sl()));
  sl.registerLazySingleton(() => GetTeacherById(sl()));
  sl.registerLazySingleton(() => CreateTeacher(sl()));
  sl.registerLazySingleton(() => UpdateTeacher(sl()));
  sl.registerLazySingleton(() => DeleteTeacher(sl()));

  sl.registerLazySingleton(() => CreateBooking(sl()));
  sl.registerLazySingleton(() => GetStudentBookings(sl()));
  sl.registerLazySingleton(() => GetTeacherBookings(sl()));
  sl.registerLazySingleton(() => UpdateBookingStatus(sl()));
  sl.registerLazySingleton(() => GetAllBookings(sl()));

  sl.registerLazySingleton(() => GetPrayerTimes(sl()));

  sl.registerLazySingleton(() => GetTeacherReviews(sl()));
  sl.registerLazySingleton(() => CreateReview(sl()));

  // ─── BLoCs ───
  sl.registerFactory(() => AuthBloc(
        signInWithGoogle: sl(),
        signInWithPhone: sl(),
        verifyPhoneCode: sl(),
        signInWithEmail: sl(),
        signOut: sl(),
        getCurrentUser: sl(),
        getUserProfile: sl(),
      ));

  sl.registerFactory(() => HomeBloc(
        getTeachers: sl(),
        getPrayerTimes: sl(),
      ));

  sl.registerFactory(() => TeacherBloc(
        getTeacherById: sl(),
        getTeacherReviews: sl(),
      ));

  sl.registerFactory(() => BookingBloc(
        createBooking: sl(),
        getStudentBookings: sl(),
        getTeacherBookings: sl(),
        updateBookingStatus: sl(),
      ));

  sl.registerFactory(() => TeacherDashboardBloc(
        getTeacherBookings: sl(),
        updateBookingStatus: sl(),
      ));

  sl.registerFactory(() => AdminBloc(
        getTeachers: sl(),
        createTeacher: sl(),
        updateTeacher: sl(),
        deleteTeacher: sl(),
        getAllBookings: sl(),
      ));
}
