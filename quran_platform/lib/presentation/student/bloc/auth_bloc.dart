import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../domain/usecases/user_usecases.dart';

// ─── Events ───
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

class AuthPhoneSignInRequested extends AuthEvent {
  final String phoneNumber;
  const AuthPhoneSignInRequested(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class AuthPhoneCodeVerified extends AuthEvent {
  final String verificationId;
  final String code;
  const AuthPhoneCodeVerified({required this.verificationId, required this.code});
  @override
  List<Object?> get props => [verificationId, code];
}

class AuthEmailSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthEmailSignInRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthProfileUpdateRequested extends AuthEvent {
  final UserEntity user;
  const AuthProfileUpdateRequested(this.user);
  @override
  List<Object?> get props => [user];
}

// ─── States ───
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthPhoneCodeSent extends AuthState {
  final String verificationId;
  const AuthPhoneCodeSent(this.verificationId);
  @override
  List<Object?> get props => [verificationId];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ───
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithPhone signInWithPhone;
  final VerifyPhoneCode verifyPhoneCode;
  final SignInWithEmail signInWithEmail;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final GetUserProfile getUserProfile;

  AuthBloc({
    required this.signInWithGoogle,
    required this.signInWithPhone,
    required this.verifyPhoneCode,
    required this.signInWithEmail,
    required this.signOut,
    required this.getCurrentUser,
    required this.getUserProfile,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheck);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
    on<AuthPhoneSignInRequested>(_onPhoneSignIn);
    on<AuthPhoneCodeVerified>(_onPhoneCodeVerified);
    on<AuthEmailSignInRequested>(_onEmailSignIn);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthProfileUpdateRequested>(_onProfileUpdate);
  }

  Future<void> _onAuthCheck(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await getCurrentUser(const NoParams());
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onGoogleSignIn(
      AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await signInWithGoogle(const NoParams());
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPhoneSignIn(
      AuthPhoneSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final verificationId = await signInWithPhone(event.phoneNumber);
      emit(AuthPhoneCodeSent(verificationId));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPhoneCodeVerified(
      AuthPhoneCodeVerified event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await verifyPhoneCode(
        VerifyPhoneCodeParams(
          verificationId: event.verificationId,
          code: event.code,
        ),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onEmailSignIn(
      AuthEmailSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await signInWithEmail(
        SignInWithEmailParams(email: event.email, password: event.password),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await signOut(const NoParams());
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onProfileUpdate(
      AuthProfileUpdateRequested event, Emitter<AuthState> emit) async {
    emit(AuthAuthenticated(event.user));
  }
}
