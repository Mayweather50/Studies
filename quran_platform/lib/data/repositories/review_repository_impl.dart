import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_datasource.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewDataSource _dataSource;

  ReviewRepositoryImpl(this._dataSource);

  @override
  Future<List<ReviewEntity>> getTeacherReviews(String teacherId) =>
      _dataSource.getTeacherReviews(teacherId);

  @override
  Future<void> createReview(ReviewEntity review) =>
      _dataSource.createReview(ReviewModel.fromEntity(review));
}
