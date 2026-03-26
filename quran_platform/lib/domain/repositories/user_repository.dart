import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getUserById(String id);
  Future<void> updateUser(UserEntity user);
  Future<void> addFavoriteTeacher(String userId, String teacherId);
  Future<void> removeFavoriteTeacher(String userId, String teacherId);
  Stream<UserEntity?> watchUser(String userId);
}
