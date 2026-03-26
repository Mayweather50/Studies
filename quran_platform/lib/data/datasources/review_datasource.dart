import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/review_model.dart';

abstract class ReviewDataSource {
  Future<List<ReviewModel>> getTeacherReviews(String teacherId);
  Future<void> createReview(ReviewModel review);
}

class ReviewDataSourceImpl implements ReviewDataSource {
  final FirebaseFirestore _firestore;

  ReviewDataSourceImpl(this._firestore);

  CollectionReference get _reviews =>
      _firestore.collection(AppConstants.reviewsCollection);

  @override
  Future<List<ReviewModel>> getTeacherReviews(String teacherId) async {
    try {
      final snapshot = await _reviews
          .where('teacherId', isEqualTo: teacherId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Ошибка загрузки отзывов: $e');
    }
  }

  @override
  Future<void> createReview(ReviewModel review) async {
    try {
      await _reviews.add(review.toFirestore());

      // Update teacher rating
      final reviews = await getTeacherReviews(review.teacherId);
      final totalRating = reviews.fold<int>(0, (sum, r) => sum + r.rating);
      final avgRating = reviews.isEmpty ? 0.0 : totalRating / reviews.length;

      await _firestore
          .collection(AppConstants.teachersCollection)
          .doc(review.teacherId)
          .update({
        'rating': avgRating,
        'reviewCount': reviews.length,
      });
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Ошибка создания отзыва: $e');
    }
  }
}
