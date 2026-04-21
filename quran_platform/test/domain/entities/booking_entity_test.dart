import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/domain/entities/booking_entity.dart';

void main() {
  group('BookingEntity', () {
    final futureDate = DateTime.now().add(const Duration(days: 7));
    final pastDate = DateTime.now().subtract(const Duration(days: 7));

    test('creates booking with all fields', () {
      final booking = BookingEntity(
        id: 'booking_1',
        studentId: 'student_1',
        teacherId: 'teacher_1',
        studentName: 'Ахмад',
        teacherName: 'Устаз Ибрахим',
        date: futureDate,
        timeSlot: '10:00',
        status: 'pending',
        discipline: 'Таджвид',
        zoomLink: 'https://zoom.us/j/123',
      );

      expect(booking.id, 'booking_1');
      expect(booking.studentId, 'student_1');
      expect(booking.teacherId, 'teacher_1');
      expect(booking.studentName, 'Ахмад');
      expect(booking.teacherName, 'Устаз Ибрахим');
      expect(booking.timeSlot, '10:00');
      expect(booking.status, 'pending');
      expect(booking.discipline, 'Таджвид');
      expect(booking.zoomLink, 'https://zoom.us/j/123');
    });

    group('status helpers', () {
      test('isPending', () {
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: futureDate, timeSlot: '10:00',
          status: 'pending', discipline: 'Таджвид',
        );
        expect(b.isPending, isTrue);
        expect(b.isConfirmed, isFalse);
        expect(b.isCancelled, isFalse);
        expect(b.isCompleted, isFalse);
      });

      test('isConfirmed', () {
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: futureDate, timeSlot: '10:00',
          status: 'confirmed', discipline: 'Таджвид',
        );
        expect(b.isConfirmed, isTrue);
        expect(b.isPending, isFalse);
      });

      test('isCancelled', () {
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: futureDate, timeSlot: '10:00',
          status: 'cancelled', discipline: 'Таджвид',
        );
        expect(b.isCancelled, isTrue);
      });

      test('isCompleted', () {
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: pastDate, timeSlot: '10:00',
          status: 'completed', discipline: 'Таджвид',
        );
        expect(b.isCompleted, isTrue);
      });
    });

    group('isUpcoming', () {
      test('future confirmed booking is upcoming', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: tomorrow, timeSlot: '23:00',
          status: 'confirmed', discipline: 'Таджвид',
        );
        expect(b.isUpcoming, isTrue);
      });

      test('future pending booking is upcoming', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: tomorrow, timeSlot: '23:00',
          status: 'pending', discipline: 'Таджвид',
        );
        expect(b.isUpcoming, isTrue);
      });

      test('cancelled booking is NOT upcoming', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: tomorrow, timeSlot: '23:00',
          status: 'cancelled', discipline: 'Таджвид',
        );
        expect(b.isUpcoming, isFalse);
      });

      test('past booking is NOT upcoming', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: yesterday, timeSlot: '00:00',
          status: 'confirmed', discipline: 'Таджвид',
        );
        expect(b.isUpcoming, isFalse);
      });

      test('invalid timeSlot format returns false', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: tomorrow, timeSlot: 'invalid',
          status: 'confirmed', discipline: 'Таджвид',
        );
        expect(b.isUpcoming, isFalse);
      });

      test('non-numeric timeSlot returns false', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: tomorrow, timeSlot: 'ab:cd',
          status: 'confirmed', discipline: 'Таджвид',
        );
        expect(b.isUpcoming, isFalse);
      });

      test('UTC date is correctly converted to local time', () {
        // Используем UTC дату с далёким будущим — должно быть upcoming
        final utcFuture = DateTime.utc(
          DateTime.now().year + 1, 1, 1, 12, 0,
        );
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: utcFuture, timeSlot: '12:00',
          status: 'confirmed', discipline: 'Таджвид',
        );
        expect(b.isUpcoming, isTrue);
      });

      test('completed booking is NOT upcoming even if future', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final b = BookingEntity(
          id: '1', studentId: 's', teacherId: 't',
          studentName: 'S', teacherName: 'T',
          date: tomorrow, timeSlot: '10:00',
          status: 'completed', discipline: 'Таджвид',
        );
        expect(b.isUpcoming, isFalse);
      });
    });

    test('Equatable comparison works', () {
      final b1 = BookingEntity(
        id: '1', studentId: 's', teacherId: 't',
        studentName: 'S', teacherName: 'T',
        date: futureDate, timeSlot: '10:00',
        status: 'pending', discipline: 'Таджвид',
      );
      final b2 = BookingEntity(
        id: '1', studentId: 's', teacherId: 't',
        studentName: 'S', teacherName: 'T',
        date: futureDate, timeSlot: '10:00',
        status: 'pending', discipline: 'Таджвид',
      );

      expect(b1, equals(b2));
    });
  });
}
