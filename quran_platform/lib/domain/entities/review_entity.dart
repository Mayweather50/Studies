import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String studentId;
  final String teacherId;
  final String bookingId;
  final String studentName;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  const ReviewEntity({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.bookingId,
    required this.studentName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, studentId, teacherId, rating];
}
