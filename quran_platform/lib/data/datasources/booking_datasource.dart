import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/booking_model.dart';

abstract class BookingDataSource {
  Future<void> createBooking(BookingModel booking);
  Future<List<BookingModel>> getStudentBookings(String studentId);
  Future<List<BookingModel>> getTeacherBookings(String teacherId);
  Future<List<BookingModel>> getAllBookings();
  Future<void> updateBookingStatus(String bookingId, String status, {String? zoomLink});
  Future<void> cancelBooking(String bookingId);
  Stream<List<BookingModel>> watchTeacherBookings(String teacherId);
  Stream<List<BookingModel>> watchStudentBookings(String studentId);
}

class BookingDataSourceImpl implements BookingDataSource {
  final FirebaseFirestore _firestore;

  BookingDataSourceImpl(this._firestore);

  CollectionReference get _bookings =>
      _firestore.collection(AppConstants.bookingsCollection);

  @override
  Future<void> createBooking(BookingModel booking) async {
    try {
      await _bookings.add(booking.toFirestore());
    } catch (e) {
      throw ServerException('Ошибка создания записи: $e');
    }
  }

  @override
  Future<List<BookingModel>> getStudentBookings(String studentId) async {
    try {
      final snapshot = await _bookings
          .where('studentId', isEqualTo: studentId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Ошибка загрузки записей: $e');
    }
  }

  @override
  Future<List<BookingModel>> getTeacherBookings(String teacherId) async {
    try {
      final snapshot = await _bookings
          .where('teacherId', isEqualTo: teacherId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Ошибка загрузки записей: $e');
    }
  }

  @override
  Future<List<BookingModel>> getAllBookings() async {
    try {
      final snapshot = await _bookings
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Ошибка загрузки записей: $e');
    }
  }

  @override
  Future<void> updateBookingStatus(String bookingId, String status,
      {String? zoomLink}) async {
    try {
      final data = <String, dynamic>{'status': status};
      if (zoomLink != null) data['zoomLink'] = zoomLink;
      await _bookings.doc(bookingId).update(data);
    } catch (e) {
      throw ServerException('Ошибка обновления записи: $e');
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _bookings.doc(bookingId).update({
        'status': AppConstants.statusCancelled,
      });
    } catch (e) {
      throw ServerException('Ошибка отмены записи: $e');
    }
  }

  @override
  Stream<List<BookingModel>> watchTeacherBookings(String teacherId) {
    return _bookings
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<BookingModel>> watchStudentBookings(String studentId) {
    return _bookings
        .where('studentId', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList());
  }
}
