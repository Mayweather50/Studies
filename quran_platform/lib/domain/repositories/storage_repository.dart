import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadTeacherPhoto(String teacherId, File file);
  Future<void> deleteTeacherPhoto(String teacherId);
}
