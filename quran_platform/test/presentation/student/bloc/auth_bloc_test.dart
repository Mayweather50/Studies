import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/core/usecases/usecase.dart';
import 'package:quran_platform/domain/entities/user_entity.dart';
import 'package:quran_platform/domain/usecases/auth_usecases.dart';
import 'package:quran_platform/domain/usecases/user_usecases.dart';
import 'package:quran_platform/presentation/student/bloc/auth_bloc.dart';

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}
class MockSignInWithPhone extends Mock implements SignInWithPhone {}
class MockVerifyPhoneCode extends Mock implements VerifyPhoneCode {}
class MockSignInWithEmail extends Mock implements SignInWithEmail {}
class MockSignOut extends Mock implements SignOut {}
class MockGetCurrentUser extends Mock implements GetCurrentUser {}
class MockGetUserProfile extends Mock implements GetUserProfile {}

void main() {
  late AuthBloc authBloc;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockSignInWithPhone mockSignInWithPhone;
  late MockVerifyPhoneCode mockVerifyPhoneCode;
  late MockSignInWithEmail mockSignInWithEmail;
  late MockSignOut mockSignOut;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockGetUserProfile mockGetUserProfile;

  const testUser = UserEntity(
    id: 'user_1',
    role: 'student',
    name: 'Ахмад',
    email: 'ahmad@test.com',
  );

  const teacherUser = UserEntity(
    id: 'teacher_1',
    role: 'teacher',
    name: 'Устаз',
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const VerifyPhoneCodeParams(
      verificationId: '', code: '',
    ));
    registerFallbackValue(const SignInWithEmailParams(
      email: '', password: '',
    ));
  });

  setUp(() {
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockSignInWithPhone = MockSignInWithPhone();
    mockVerifyPhoneCode = MockVerifyPhoneCode();
    mockSignInWithEmail = MockSignInWithEmail();
    mockSignOut = MockSignOut();
    mockGetCurrentUser = MockGetCurrentUser();
    mockGetUserProfile = MockGetUserProfile();

    authBloc = AuthBloc(
      signInWithGoogle: mockSignInWithGoogle,
      signInWithPhone: mockSignInWithPhone,
      verifyPhoneCode: mockVerifyPhoneCode,
      signInWithEmail: mockSignInWithEmail,
      signOut: mockSignOut,
      getCurrentUser: mockGetCurrentUser,
      getUserProfile: mockGetUserProfile,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state is AuthInitial', () {
    expect(authBloc.state, const AuthInitial());
  });

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when user is logged in',
      build: () {
        when(() => mockGetCurrentUser(any()))
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when no user',
      build: () {
        when(() => mockGetCurrentUser(any()))
            .thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] on error',
      build: () {
        when(() => mockGetCurrentUser(any()))
            .thenThrow(Exception('Network error'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });

  group('AuthGoogleSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(() => mockSignInWithGoogle(any()))
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthGoogleSignInRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => mockSignInWithGoogle(any()))
            .thenThrow(Exception('Google sign-in failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthGoogleSignInRequested()),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>(),
      ],
    );
  });

  group('AuthPhoneSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthPhoneCodeSent] on success',
      build: () {
        when(() => mockSignInWithPhone(any()))
            .thenAnswer((_) async => 'verification_id_123');
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthPhoneSignInRequested('+79991234567')),
      expect: () => [
        const AuthLoading(),
        const AuthPhoneCodeSent('verification_id_123'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => mockSignInWithPhone(any()))
            .thenThrow(Exception('SMS failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthPhoneSignInRequested('+79991234567')),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>(),
      ],
    );
  });

  group('AuthPhoneCodeVerified', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on valid code',
      build: () {
        when(() => mockVerifyPhoneCode(any()))
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthPhoneCodeVerified(
        verificationId: 'vid', code: '123456',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on invalid code',
      build: () {
        when(() => mockVerifyPhoneCode(any()))
            .thenThrow(Exception('Invalid code'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthPhoneCodeVerified(
        verificationId: 'vid', code: '000000',
      )),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>(),
      ],
    );
  });

  group('AuthEmailSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(() => mockSignInWithEmail(any()))
            .thenAnswer((_) async => teacherUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthEmailSignInRequested(
        email: 'teacher@test.com', password: 'password',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(teacherUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on wrong credentials',
      build: () {
        when(() => mockSignInWithEmail(any()))
            .thenThrow(Exception('Wrong password'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthEmailSignInRequested(
        email: 'wrong@test.com', password: 'wrong',
      )),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>(),
      ],
    );
  });

  group('AuthSignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] on sign out',
      build: () {
        when(() => mockSignOut(any()))
            .thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });

  group('AuthProfileUpdateRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthAuthenticated] with updated user',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthProfileUpdateRequested(testUser)),
      expect: () => [
        const AuthAuthenticated(testUser),
      ],
    );
  });
}
