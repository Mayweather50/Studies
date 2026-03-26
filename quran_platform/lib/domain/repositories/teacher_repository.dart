import '../entities/teacher_entity.dart';

abstract class TeacherRepository {
  Future<List<TeacherEntity>> getTeachers({
    String? discipline,
    String? ageGroup,
    String? level,
    String? searchQuery,
  });
  Future<TeacherEntity?> getTeacherById(String id);
  Future<void> createTeacher(TeacherEntity teacher);
  Future<void> updateTeacher(TeacherEntity teacher);
  Future<void> deleteTeacher(String id);
  Future<List<String>> getAvailableSlots(String teacherId, DateTime date);
  Stream<List<TeacherEntity>> watchTeachers();
}
