import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/domain/entities/review_entity.dart';

void main() {
  group('ReviewEntity', () {
    test('creates review with all fields', () {
      const review = ReviewEntity(
        id: 'review_1',
        studentId: 'student_1',
        teacherId: 'teacher_1',
        bookingId: 'booking_1',
        studentName: 'Ахмад',
        rating: 5,
        comment: 'Отличный учитель!',
      );

      expect(review.id, 'review_1');
      expect(review.studentId, 'student_1');
      expect(review.teacherId, 'teacher_1');
      expect(review.bookingId, 'booking_1');
      expect(review.studentName, 'Ахмад');
      expect(review.rating, 5);
      expect(review.comment, 'Отличный учитель!');
      expect(review.createdAt, isNull);
    });

    test('Equatable comparison based on id, studentId, teacherId, rating', () {
      const r1 = ReviewEntity(
        id: '1', studentId: 's', teacherId: 't',
        bookingId: 'b', studentName: 'S',
        rating: 5, comment: 'Good',
      );
      const r2 = ReviewEntity(
        id: '1', studentId: 's', teacherId: 't',
        bookingId: 'b', studentName: 'S',
        rating: 5, comment: 'Different comment',
      );
      const r3 = ReviewEntity(
        id: '2', studentId: 's', teacherId: 't',
        bookingId: 'b', studentName: 'S',
        rating: 5, comment: 'Good',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
    });
  });
}
