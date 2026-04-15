import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/domain/entities/review_entity.dart';
import 'package:quran_platform/domain/repositories/review_repository.dart';
import 'package:quran_platform/domain/usecases/review_usecases.dart';

class MockReviewRepository extends Mock implements ReviewRepository {}

void main() {
  late MockReviewRepository mockRepo;

  final testReview1 = ReviewEntity(
    id: 'r1',
    studentId: 's1',
    teacherId: 't1',
    bookingId: 'b1',
    studentName: 'Ахмад',
    rating: 5,
    comment: 'Отличный устаз, очень терпеливый',
    createdAt: DateTime(2026, 4, 1),
  );

  final testReview2 = ReviewEntity(
    id: 'r2',
    studentId: 's2',
    teacherId: 't1',
    bookingId: 'b2',
    studentName: 'Мухаммад',
    rating: 4,
    comment: 'Хороший преподаватель',
    createdAt: DateTime(2026, 4, 5),
  );

  setUp(() {
    mockRepo = MockReviewRepository();
  });

  setUpAll(() {
    registerFallbackValue(testReview1);
  });

  group('GetTeacherReviews', () {
    test('returns reviews for teacher', () async {
      when(() => mockRepo.getTeacherReviews('t1'))
          .thenAnswer((_) async => [testReview1, testReview2]);

      final useCase = GetTeacherReviews(mockRepo);
      final result = await useCase('t1');

      expect(result.length, 2);
      expect(result.first.rating, 5);
      expect(result.last.rating, 4);
      verify(() => mockRepo.getTeacherReviews('t1')).called(1);
    });

    test('returns empty list for teacher with no reviews', () async {
      when(() => mockRepo.getTeacherReviews('t_new'))
          .thenAnswer((_) async => []);

      final useCase = GetTeacherReviews(mockRepo);
      final result = await useCase('t_new');

      expect(result, isEmpty);
    });
  });

  group('CreateReview', () {
    test('calls repository.createReview', () async {
      when(() => mockRepo.createReview(any()))
          .thenAnswer((_) async {});

      final useCase = CreateReview(mockRepo);
      await useCase(testReview1);

      verify(() => mockRepo.createReview(testReview1)).called(1);
    });
  });
}
