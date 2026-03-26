import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_datasource.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingDataSource _dataSource;

  BookingRepositoryImpl(this._dataSource);

  @override
  Future<void> createBooking(BookingEntity booking) =>
      _dataSource.createBooking(BookingModel.fromEntity(booking));

  @override
  Future<List<BookingEntity>> getStudentBookings(String studentId) =>
      _dataSource.getStudentBookings(studentId);

  @override
  Future<List<BookingEntity>> getTeacherBookings(String teacherId) =>
      _dataSource.getTeacherBookings(teacherId);

  @override
  Future<List<BookingEntity>> getAllBookings() => _dataSource.getAllBookings();

  @override
  Future<void> updateBookingStatus(String bookingId, String status,
          {String? zoomLink}) =>
      _dataSource.updateBookingStatus(bookingId, status, zoomLink: zoomLink);

  @override
  Future<void> cancelBooking(String bookingId) =>
      _dataSource.cancelBooking(bookingId);

  @override
  Stream<List<BookingEntity>> watchTeacherBookings(String teacherId) =>
      _dataSource.watchTeacherBookings(teacherId);

  @override
  Stream<List<BookingEntity>> watchStudentBookings(String studentId) =>
      _dataSource.watchStudentBookings(studentId);
}
