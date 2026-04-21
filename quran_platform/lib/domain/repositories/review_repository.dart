import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<List<ReviewEntity>> getTeacherReviews(String teacherId);
  Future<void> createReview(ReviewEntity review);
}
