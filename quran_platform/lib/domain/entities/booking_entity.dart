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
    if (parts.length < 2) return false;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return false;
    final localDate = date.toLocal();
    final slotDateTime = DateTime(
      localDate.year, localDate.month, localDate.day,
      hour, minute,
    );
    return slotDateTime.isAfter(now) && (isConfirmed || isPending);
  }

  @override
  List<Object?> get props => [id, studentId, teacherId, date, timeSlot, status];
}
