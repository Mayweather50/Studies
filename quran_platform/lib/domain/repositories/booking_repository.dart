import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<void> createBooking(BookingEntity booking);
  Future<List<BookingEntity>> getStudentBookings(String studentId);
  Future<List<BookingEntity>> getTeacherBookings(String teacherId);
  Future<List<BookingEntity>> getAllBookings();
  Future<void> updateBookingStatus(String bookingId, String status, {String? zoomLink});
  Future<void> cancelBooking(String bookingId);
  Stream<List<BookingEntity>> watchTeacherBookings(String teacherId);
  Stream<List<BookingEntity>> watchStudentBookings(String studentId);
}
