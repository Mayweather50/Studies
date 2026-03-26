import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signInWithGoogle();
  Future<String> signInWithPhone(String phoneNumber);
  Future<UserModel> verifyPhoneCode(String verificationId, String code);
  Future<UserModel> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> createUserProfile(UserModel user);
  Stream<User?> get authStateChanges;
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthDataSourceImpl(this._auth, this._firestore);

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw const AuthException('Вход отменён');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) throw const AuthException('Не удалось войти');

      // Check if user profile exists
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        final newUser = UserModel(
          id: user.uid,
          role: AppConstants.roleStudent,
          name: user.displayName ?? '',
          email: user.email,
          avatarUrl: user.photoURL,
          createdAt: DateTime.now(),
        );
        await createUserProfile(newUser);
        return newUser;
      }

      return UserModel.fromFirestore(doc);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Ошибка авторизации Google');
    }
  }

  @override
  Future<String> signInWithPhone(String phoneNumber) async {
    try {
      String verificationId = '';

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          throw AuthException(e.message ?? 'Ошибка верификации');
        },
        codeSent: (id, _) {
          verificationId = id;
        },
        codeAutoRetrievalTimeout: (_) {},
        timeout: const Duration(seconds: 60),
      );

      // Wait a bit for the callback
      await Future.delayed(const Duration(seconds: 2));
      return verificationId;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Ошибка отправки SMS');
    }
  }

  @override
  Future<UserModel> verifyPhoneCode(String verificationId, String code) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) throw const AuthException('Не удалось войти');

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        final newUser = UserModel(
          id: user.uid,
          role: AppConstants.roleStudent,
          name: '',
          phone: user.phoneNumber,
          createdAt: DateTime.now(),
        );
        await createUserProfile(newUser);
        return newUser;
      }

      return UserModel.fromFirestore(doc);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Неверный код');
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) throw const AuthException('Не удалось войти');

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) throw const AuthException('Профиль не найден');

      return UserModel.fromFirestore(doc);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Неверный email или пароль');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<void> createUserProfile(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(user.toFirestore());
  }

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
