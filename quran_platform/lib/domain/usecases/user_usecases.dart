import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../core/usecases/usecase.dart';

class GetUserProfile extends UseCase<UserEntity?, String> {
  final UserRepository repository;
  GetUserProfile(this.repository);

  @override
  Future<UserEntity?> call(String userId) => repository.getUserById(userId);
}

class UpdateUserProfile extends UseCase<void, UserEntity> {
  final UserRepository repository;
  UpdateUserProfile(this.repository);

  @override
  Future<void> call(UserEntity user) => repository.updateUser(user);
}
