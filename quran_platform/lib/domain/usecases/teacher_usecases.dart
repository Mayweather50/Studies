import '../entities/teacher_entity.dart';
import '../repositories/teacher_repository.dart';
import '../../core/usecases/usecase.dart';

class GetTeachers extends UseCase<List<TeacherEntity>, GetTeachersParams> {
  final TeacherRepository repository;
  GetTeachers(this.repository);

  @override
  Future<List<TeacherEntity>> call(GetTeachersParams params) =>
      repository.getTeachers(
        discipline: params.discipline,
        ageGroup: params.ageGroup,
        level: params.level,
        searchQuery: params.searchQuery,
      );
}

class GetTeachersParams {
  final String? discipline;
  final String? ageGroup;
  final String? level;
  final String? searchQuery;

  const GetTeachersParams({
    this.discipline,
    this.ageGroup,
    this.level,
    this.searchQuery,
  });
}

class GetTeacherById extends UseCase<TeacherEntity?, String> {
  final TeacherRepository repository;
  GetTeacherById(this.repository);

  @override
  Future<TeacherEntity?> call(String id) => repository.getTeacherById(id);
}

class CreateTeacher extends UseCase<void, TeacherEntity> {
  final TeacherRepository repository;
  CreateTeacher(this.repository);

  @override
  Future<void> call(TeacherEntity teacher) => repository.createTeacher(teacher);
}

class UpdateTeacher extends UseCase<void, TeacherEntity> {
  final TeacherRepository repository;
  UpdateTeacher(this.repository);

  @override
  Future<void> call(TeacherEntity teacher) => repository.updateTeacher(teacher);
}

class DeleteTeacher extends UseCase<void, String> {
  final TeacherRepository repository;
  DeleteTeacher(this.repository);

  @override
  Future<void> call(String id) => repository.deleteTeacher(id);
}
