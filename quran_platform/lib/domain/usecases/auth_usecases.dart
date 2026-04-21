import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../core/usecases/usecase.dart';

class SignInWithGoogle extends UseCase<UserEntity, NoParams> {
  final AuthRepository repository;
  SignInWithGoogle(this.repository);

  @override
  Future<UserEntity> call(NoParams params) => repository.signInWithGoogle();
}

class SignInWithPhone extends UseCase<String, String> {
  final AuthRepository repository;
  SignInWithPhone(this.repository);

  @override
  Future<String> call(String phoneNumber) => repository.signInWithPhone(phoneNumber);
}

class VerifyPhoneCode extends UseCase<UserEntity, VerifyPhoneCodeParams> {
  final AuthRepository repository;
  VerifyPhoneCode(this.repository);

  @override
  Future<UserEntity> call(VerifyPhoneCodeParams params) =>
      repository.verifyPhoneCode(params.verificationId, params.code);
}

class VerifyPhoneCodeParams {
  final String verificationId;
  final String code;
  const VerifyPhoneCodeParams({required this.verificationId, required this.code});
}

class SignInWithEmail extends UseCase<UserEntity, SignInWithEmailParams> {
  final AuthRepository repository;
  SignInWithEmail(this.repository);

  @override
  Future<UserEntity> call(SignInWithEmailParams params) =>
      repository.signInWithEmail(params.email, params.password);
}

class SignInWithEmailParams {
  final String email;
  final String password;
  const SignInWithEmailParams({required this.email, required this.password});
}

class SignOut extends UseCase<void, NoParams> {
  final AuthRepository repository;
  SignOut(this.repository);

  @override
  Future<void> call(NoParams params) => repository.signOut();
}

class GetCurrentUser extends UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  @override
  Future<UserEntity?> call(NoParams params) => repository.getCurrentUser();
}
