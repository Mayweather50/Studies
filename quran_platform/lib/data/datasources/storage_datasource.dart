import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../core/errors/exceptions.dart';

abstract class StorageDataSource {
  Future<String> uploadTeacherPhoto(String teacherId, File file);
  Future<void> deleteTeacherPhoto(String teacherId);
}

class StorageDataSourceImpl implements StorageDataSource {
  final FirebaseStorage _storage;

  StorageDataSourceImpl(this._storage);

  @override
  Future<String> uploadTeacherPhoto(String teacherId, File file) async {
    try {
      final ref = _storage.ref().child('teachers/$teacherId/photo.jpg');
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw StorageException('Ошибка загрузки фото: $e');
    }
  }

  @override
  Future<void> deleteTeacherPhoto(String teacherId) async {
    try {
      final ref = _storage.ref().child('teachers/$teacherId/photo.jpg');
      await ref.delete();
    } catch (e) {
      throw StorageException('Ошибка удаления фото: $e');
    }
  }
}
