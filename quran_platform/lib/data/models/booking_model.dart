import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.studentId,
    required super.teacherId,
    required super.studentName,
    required super.teacherName,
    required super.date,
    required super.timeSlot,
    required super.status,
    super.zoomLink,
    required super.discipline,
    super.createdAt,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      teacherId: data['teacherId'] ?? '',
      studentName: data['studentName'] ?? '',
      teacherName: data['teacherName'] ?? '',
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      timeSlot: data['timeSlot'] ?? '',
      status: data['status'] ?? 'pending',
      zoomLink: data['zoomLink'],
      discipline: data['discipline'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      studentId: entity.studentId,
      teacherId: entity.teacherId,
      studentName: entity.studentName,
      teacherName: entity.teacherName,
      date: entity.date,
      timeSlot: entity.timeSlot,
      status: entity.status,
      zoomLink: entity.zoomLink,
      discipline: entity.discipline,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'studentName': studentName,
      'teacherName': teacherName,
      'date': Timestamp.fromDate(date),
      'timeSlot': timeSlot,
      'status': status,
      if (zoomLink != null) 'zoomLink': zoomLink,
      'discipline': discipline,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
