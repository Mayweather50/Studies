import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/teacher_model.dart';

abstract class TeacherDataSource {
  Future<List<TeacherModel>> getTeachers({
    String? discipline,
    String? ageGroup,
    String? level,
    String? searchQuery,
  });
  Future<TeacherModel?> getTeacherById(String id);
  Future<void> createTeacher(TeacherModel teacher);
  Future<void> updateTeacher(TeacherModel teacher);
  Future<void> deleteTeacher(String id);
  Future<List<String>> getAvailableSlots(String teacherId, DateTime date);
  Stream<List<TeacherModel>> watchTeachers();
}

class TeacherDataSourceImpl implements TeacherDataSource {
  final FirebaseFirestore _firestore;

  TeacherDataSourceImpl(this._firestore);

  CollectionReference get _teachers =>
      _firestore.collection(AppConstants.teachersCollection);

  @override
  Future<List<TeacherModel>> getTeachers({
    String? discipline,
    String? ageGroup,
    String? level,
    String? searchQuery,
  }) async {
    try {
      Query query = _teachers.where('isActive', isEqualTo: true);

      if (discipline != null && discipline.isNotEmpty) {
        query = query.where('disciplines', arrayContains: discipline);
      }

      final snapshot = await query.get();
      var teachers = snapshot.docs
          .map((doc) => TeacherModel.fromFirestore(doc))
          .toList();

      // Client-side filtering for multiple array-contains
      if (ageGroup != null && ageGroup.isNotEmpty) {
        teachers = teachers
            .where((t) => t.ageGroups.contains(ageGroup))
            .toList();
      }
      if (level != null && level.isNotEmpty) {
        teachers = teachers
            .where((t) => t.levels.contains(level))
            .toList();
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        teachers = teachers
            .where((t) => t.name.toLowerCase().contains(q) ||
                t.bio.toLowerCase().contains(q))
            .toList();
      }

      return teachers;
    } catch (e) {
      throw ServerException('Ошибка загрузки учителей: $e');
    }
  }

  @override
  Future<TeacherModel?> getTeacherById(String id) async {
    try {
      final doc = await _teachers.doc(id).get();
      if (!doc.exists) return null;
      return TeacherModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Ошибка загрузки учителя: $e');
    }
  }

  @override
  Future<void> createTeacher(TeacherModel teacher) async {
    try {
      if (teacher.id.isEmpty) {
        await _teachers.add(teacher.toFirestore());
      } else {
        await _teachers.doc(teacher.id).set(teacher.toFirestore());
      }
    } catch (e) {
      throw ServerException('Ошибка создания учителя: $e');
    }
  }

  @override
  Future<void> updateTeacher(TeacherModel teacher) async {
    try {
      await _teachers.doc(teacher.id).update(teacher.toFirestore());
    } catch (e) {
      throw ServerException('Ошибка обновления учителя: $e');
    }
  }

  @override
  Future<void> deleteTeacher(String id) async {
    try {
      await _teachers.doc(id).delete();
    } catch (e) {
      throw ServerException('Ошибка удаления учителя: $e');
    }
  }

  @override
  Future<List<String>> getAvailableSlots(String teacherId, DateTime date) async {
    try {
      final doc = await _teachers.doc(teacherId).get();
      if (!doc.exists) return [];

      final teacher = TeacherModel.fromFirestore(doc);
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      return teacher.schedule[dateKey] ?? [];
    } catch (e) {
      throw ServerException('Ошибка загрузки слотов: $e');
    }
  }

  @override
  Stream<List<TeacherModel>> watchTeachers() {
    return _teachers
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TeacherModel.fromFirestore(doc))
            .toList());
  }
}
