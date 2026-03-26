import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String role;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? age;
  final String? level;
  final List<String> favoriteTeachers;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.role,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.age,
    this.level,
    this.favoriteTeachers = const [],
    this.createdAt,
  });

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [id, role, name, email, phone, avatarUrl, age, level];
}
