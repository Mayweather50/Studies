import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/teacher_entity.dart';

class TeacherModel extends TeacherEntity {
  const TeacherModel({
    required super.id,
    required super.name,
    required super.bio,
    required super.experience,
    super.photoUrl,
    super.disciplines,
    super.ageGroups,
    super.levels,
    super.rating,
    super.reviewCount,
    super.isActive,
    super.schedule,
    super.userId,
    super.createdAt,
  });

  factory TeacherModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final rawSchedule = data['schedule'] as Map<String, dynamic>? ?? {};
    final schedule = rawSchedule.map(
      (key, value) => MapEntry(key, List<String>.from(value)),
    );

    return TeacherModel(
      id: doc.id,
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      experience: data['experience'] ?? '',
      photoUrl: data['photoUrl'],
      disciplines: List<String>.from(data['disciplines'] ?? []),
      ageGroups: List<String>.from(data['ageGroups'] ?? []),
      levels: List<String>.from(data['levels'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      isActive: data['isActive'] ?? true,
      schedule: schedule,
      userId: data['userId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory TeacherModel.fromEntity(TeacherEntity entity) {
    return TeacherModel(
      id: entity.id,
      name: entity.name,
      bio: entity.bio,
      experience: entity.experience,
      photoUrl: entity.photoUrl,
      disciplines: entity.disciplines,
      ageGroups: entity.ageGroups,
      levels: entity.levels,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      isActive: entity.isActive,
      schedule: entity.schedule,
      userId: entity.userId,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'bio': bio,
      'experience': experience,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'disciplines': disciplines,
      'ageGroups': ageGroups,
      'levels': levels,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
      'schedule': schedule,
      if (userId != null) 'userId': userId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
