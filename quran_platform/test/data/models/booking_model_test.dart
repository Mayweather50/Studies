import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/data/models/booking_model.dart';
import 'package:quran_platform/domain/entities/booking_entity.dart';

void main() {
  group('BookingModel', () {
    test('fromEntity preserves all fields', () {
      final entity = BookingEntity(
        id: 'b1',
        studentId: 's1',
        teacherId: 't1',
        studentName: 'Ахмад',
        teacherName: 'Устаз',
        date: DateTime(2024, 6, 15),
        timeSlot: '10:00',
        status: 'pending',
        discipline: 'Таджвид',
        zoomLink: 'https://zoom.us/j/123',
      );

      final model = BookingModel.fromEntity(entity);

      expect(model.id, 'b1');
      expect(model.studentId, 's1');
      expect(model.teacherId, 't1');
      expect(model.studentName, 'Ахмад');
      expect(model.teacherName, 'Устаз');
      expect(model.date, DateTime(2024, 6, 15));
      expect(model.timeSlot, '10:00');
      expect(model.status, 'pending');
      expect(model.discipline, 'Таджвид');
      expect(model.zoomLink, 'https://zoom.us/j/123');
    });

    test('toFirestore creates correct map', () {
      final model = BookingModel(
        id: 'b1',
        studentId: 's1',
        teacherId: 't1',
        studentName: 'Ахмад',
        teacherName: 'Устаз',
        date: DateTime(2024, 6, 15),
        timeSlot: '10:00',
        status: 'confirmed',
        discipline: 'Таджвид',
        zoomLink: 'https://zoom.us/j/456',
      );

      final map = model.toFirestore();

      expect(map['studentId'], 's1');
      expect(map['teacherId'], 't1');
      expect(map['studentName'], 'Ахмад');
      expect(map['teacherName'], 'Устаз');
      expect(map['timeSlot'], '10:00');
      expect(map['status'], 'confirmed');
      expect(map['discipline'], 'Таджвид');
      expect(map['zoomLink'], 'https://zoom.us/j/456');
      expect(map.containsKey('date'), isTrue);
    });

    test('toFirestore omits null zoomLink', () {
      final model = BookingModel(
        id: 'b1', studentId: 's1', teacherId: 't1',
        studentName: 'S', teacherName: 'T',
        date: DateTime(2024, 1, 1), timeSlot: '10:00',
        status: 'pending', discipline: 'Таджвид',
      );

      final map = model.toFirestore();
      expect(map.containsKey('zoomLink'), isFalse);
    });

    test('BookingModel is a BookingEntity', () {
      final model = BookingModel(
        id: '1', studentId: 's', teacherId: 't',
        studentName: 'S', teacherName: 'T',
        date: DateTime.now(), timeSlot: '10:00',
        status: 'pending', discipline: 'D',
      );
      expect(model, isA<BookingEntity>());
    });

    test('fromEntity preserves null zoomLink', () {
      final entity = BookingEntity(
        id: 'b1', studentId: 's1', teacherId: 't1',
        studentName: 'S', teacherName: 'T',
        date: DateTime(2024, 1, 1), timeSlot: '10:00',
        status: 'pending', discipline: 'Таджвид',
      );

      final model = BookingModel.fromEntity(entity);
      expect(model.zoomLink, isNull);
    });
  });
}
