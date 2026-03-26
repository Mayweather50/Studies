import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithGoogle();
  Future<String> signInWithPhone(String phoneNumber);
  Future<UserEntity> verifyPhoneCode(String verificationId, String code);
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> createUserProfile(UserEntity user);
  Stream<UserEntity?> get authStateChanges;
}
