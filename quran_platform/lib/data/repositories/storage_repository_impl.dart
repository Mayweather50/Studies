import 'dart:io';

import '../../domain/repositories/storage_repository.dart';
import '../datasources/storage_datasource.dart';

class StorageRepositoryImpl implements StorageRepository {
  final StorageDataSource _dataSource;

  StorageRepositoryImpl(this._dataSource);

  @override
  Future<String> uploadTeacherPhoto(String teacherId, File file) =>
      _dataSource.uploadTeacherPhoto(teacherId, file);

  @override
  Future<void> deleteTeacherPhoto(String teacherId) =>
      _dataSource.deleteTeacherPhoto(teacherId);
}
