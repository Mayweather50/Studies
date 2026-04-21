import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/data/models/review_model.dart';
import 'package:quran_platform/domain/entities/review_entity.dart';

void main() {
  group('ReviewModel', () {
    test('fromEntity preserves all fields', () {
      const entity = ReviewEntity(
        id: 'r1',
        studentId: 's1',
        teacherId: 't1',
        bookingId: 'b1',
        studentName: 'Ахмад',
        rating: 5,
        comment: 'Отличный учитель!',
      );

      final model = ReviewModel.fromEntity(entity);

      expect(model.id, 'r1');
      expect(model.studentId, 's1');
      expect(model.teacherId, 't1');
      expect(model.bookingId, 'b1');
      expect(model.studentName, 'Ахмад');
      expect(model.rating, 5);
      expect(model.comment, 'Отличный учитель!');
    });

    test('toFirestore creates correct map', () {
      const model = ReviewModel(
        id: 'r1',
        studentId: 's1',
        teacherId: 't1',
        bookingId: 'b1',
        studentName: 'Ахмад',
        rating: 4,
        comment: 'Хорошо',
      );

      final map = model.toFirestore();

      expect(map['studentId'], 's1');
      expect(map['teacherId'], 't1');
      expect(map['bookingId'], 'b1');
      expect(map['studentName'], 'Ахмад');
      expect(map['rating'], 4);
      expect(map['comment'], 'Хорошо');
    });

    test('ReviewModel is a ReviewEntity', () {
      const model = ReviewModel(
        id: '1', studentId: 's', teacherId: 't',
        bookingId: 'b', studentName: 'S',
        rating: 5, comment: 'Good',
      );
      expect(model, isA<ReviewEntity>());
    });
  });
}
