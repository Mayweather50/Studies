import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String studentId;
  final String teacherId;
  final String studentName;
  final String teacherName;
  final DateTime date;
  final String timeSlot;
  final String status; // pending, confirmed, cancelled, completed
  final String? zoomLink;
  final String discipline;
  final DateTime? createdAt;

  const BookingEntity({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.studentName,
    required this.teacherName,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.zoomLink,
    required this.discipline,
    this.createdAt,
  });

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  bool get isUpcoming {
    final now = DateTime.now();
    final parts = timeSlot.split(':');
    final slotDateTime = DateTime(
      date.year, date.month, date.day,
      int.parse(parts[0]), int.parse(parts[1]),
    );
    return slotDateTime.isAfter(now) && (isConfirmed || isPending);
  }

  @override
  List<Object?> get props => [id, studentId, teacherId, date, timeSlot, status];
}
