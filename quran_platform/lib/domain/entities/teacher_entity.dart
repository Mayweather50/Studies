import 'package:equatable/equatable.dart';

class TeacherEntity extends Equatable {
  final String id;
  final String name;
  final String bio;
  final String experience;
  final String? photoUrl;
  final List<String> disciplines;
  final List<String> ageGroups;
  final List<String> levels;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final Map<String, List<String>> schedule; // date -> [timeSlots]
  final String? userId; // linked Firebase Auth user id
  final DateTime? createdAt;

  const TeacherEntity({
    required this.id,
    required this.name,
    required this.bio,
    required this.experience,
    this.photoUrl,
    this.disciplines = const [],
    this.ageGroups = const [],
    this.levels = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isActive = true,
    this.schedule = const {},
    this.userId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, bio, experience, photoUrl, isActive, rating];
}
