import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel?> getUserById(String id);
  Future<void> updateUser(UserModel user);
  Future<void> addFavoriteTeacher(String userId, String teacherId);
  Future<void> removeFavoriteTeacher(String userId, String teacherId);
  Stream<UserModel?> watchUser(String userId);
}

class UserDataSourceImpl implements UserDataSource {
  final FirebaseFirestore _firestore;

  UserDataSourceImpl(this._firestore);

  CollectionReference get _users =>
      _firestore.collection(AppConstants.usersCollection);

  @override
  Future<UserModel?> getUserById(String id) async {
    try {
      final doc = await _users.doc(id).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Ошибка загрузки профиля: $e');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _users.doc(user.id).update(user.toFirestore());
    } catch (e) {
      throw ServerException('Ошибка обновления профиля: $e');
    }
  }

  @override
  Future<void> addFavoriteTeacher(String userId, String teacherId) async {
    try {
      await _users.doc(userId).update({
        'favoriteTeachers': FieldValue.arrayUnion([teacherId]),
      });
    } catch (e) {
      throw ServerException('Ошибка: $e');
    }
  }

  @override
  Future<void> removeFavoriteTeacher(String userId, String teacherId) async {
    try {
      await _users.doc(userId).update({
        'favoriteTeachers': FieldValue.arrayRemove([teacherId]),
      });
    } catch (e) {
      throw ServerException('Ошибка: $e');
    }
  }

  @override
  Stream<UserModel?> watchUser(String userId) {
    return _users.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }
}
