import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../datasources/user_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final UserDataSource _userDataSource;

  AuthRepositoryImpl(this._authDataSource, this._userDataSource);

  @override
  Future<UserEntity> signInWithGoogle() => _authDataSource.signInWithGoogle();

  @override
  Future<String> signInWithPhone(String phoneNumber) =>
      _authDataSource.signInWithPhone(phoneNumber);

  @override
  Future<UserEntity> verifyPhoneCode(String verificationId, String code) =>
      _authDataSource.verifyPhoneCode(verificationId, code);

  @override
  Future<UserEntity> signInWithEmail(String email, String password) =>
      _authDataSource.signInWithEmail(email, password);

  @override
  Future<void> signOut() => _authDataSource.signOut();

  @override
  Future<UserEntity?> getCurrentUser() => _authDataSource.getCurrentUser();

  @override
  Future<void> createUserProfile(UserEntity user) =>
      _authDataSource.createUserProfile(UserModel.fromEntity(user));

  @override
  Stream<UserEntity?> get authStateChanges =>
      _authDataSource.authStateChanges.asyncMap((firebaseUser) async {
        if (firebaseUser == null) return null;
        return _userDataSource.getUserById(firebaseUser.uid);
      });
}
