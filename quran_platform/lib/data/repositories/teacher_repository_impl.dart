import '../../domain/entities/teacher_entity.dart';
import '../../domain/repositories/teacher_repository.dart';
import '../datasources/teacher_datasource.dart';
import '../models/teacher_model.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherDataSource _dataSource;

  TeacherRepositoryImpl(this._dataSource);

  @override
  Future<List<TeacherEntity>> getTeachers({
    String? discipline,
    String? ageGroup,
    String? level,
    String? searchQuery,
  }) =>
      _dataSource.getTeachers(
        discipline: discipline,
        ageGroup: ageGroup,
        level: level,
        searchQuery: searchQuery,
      );

  @override
  Future<TeacherEntity?> getTeacherById(String id) =>
      _dataSource.getTeacherById(id);

  @override
  Future<void> createTeacher(TeacherEntity teacher) =>
      _dataSource.createTeacher(TeacherModel.fromEntity(teacher));

  @override
  Future<void> updateTeacher(TeacherEntity teacher) =>
      _dataSource.updateTeacher(TeacherModel.fromEntity(teacher));

  @override
  Future<void> deleteTeacher(String id) => _dataSource.deleteTeacher(id);

  @override
  Future<List<String>> getAvailableSlots(String teacherId, DateTime date) =>
      _dataSource.getAvailableSlots(teacherId, date);

  @override
  Stream<List<TeacherEntity>> watchTeachers() => _dataSource.watchTeachers();
}
