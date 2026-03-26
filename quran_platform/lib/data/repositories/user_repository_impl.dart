import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _dataSource;

  UserRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity?> getUserById(String id) => _dataSource.getUserById(id);

  @override
  Future<void> updateUser(UserEntity user) =>
      _dataSource.updateUser(UserModel.fromEntity(user));

  @override
  Future<void> addFavoriteTeacher(String userId, String teacherId) =>
      _dataSource.addFavoriteTeacher(userId, teacherId);

  @override
  Future<void> removeFavoriteTeacher(String userId, String teacherId) =>
      _dataSource.removeFavoriteTeacher(userId, teacherId);

  @override
  Stream<UserEntity?> watchUser(String userId) =>
      _dataSource.watchUser(userId);
}
