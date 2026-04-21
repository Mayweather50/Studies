import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.role,
    required super.name,
    super.email,
    super.phone,
    super.avatarUrl,
    super.age,
    super.level,
    super.favoriteTeachers,
    super.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      role: data['role'] ?? 'student',
      name: data['name'] ?? '',
      email: data['email'],
      phone: data['phone'],
      avatarUrl: data['avatarUrl'],
      age: data['age'],
      level: data['level'],
      favoriteTeachers: List<String>.from(data['favoriteTeachers'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      role: entity.role,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      avatarUrl: entity.avatarUrl,
      age: entity.age,
      level: entity.level,
      favoriteTeachers: entity.favoriteTeachers,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (age != null) 'age': age,
      if (level != null) 'level': level,
      'favoriteTeachers': favoriteTeachers,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
