import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';
import '../../core/usecases/usecase.dart';

class GetTeacherReviews extends UseCase<List<ReviewEntity>, String> {
  final ReviewRepository repository;
  GetTeacherReviews(this.repository);

  @override
  Future<List<ReviewEntity>> call(String teacherId) =>
      repository.getTeacherReviews(teacherId);
}

class CreateReview extends UseCase<void, ReviewEntity> {
  final ReviewRepository repository;
  CreateReview(this.repository);

  @override
  Future<void> call(ReviewEntity review) => repository.createReview(review);
}
