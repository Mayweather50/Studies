import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';
import '../../core/usecases/usecase.dart';

class CreateBooking extends UseCase<void, BookingEntity> {
  final BookingRepository repository;
  CreateBooking(this.repository);

  @override
  Future<void> call(BookingEntity booking) => repository.createBooking(booking);
}

class GetStudentBookings extends UseCase<List<BookingEntity>, String> {
  final BookingRepository repository;
  GetStudentBookings(this.repository);

  @override
  Future<List<BookingEntity>> call(String studentId) =>
      repository.getStudentBookings(studentId);
}

class GetTeacherBookings extends UseCase<List<BookingEntity>, String> {
  final BookingRepository repository;
  GetTeacherBookings(this.repository);

  @override
  Future<List<BookingEntity>> call(String teacherId) =>
      repository.getTeacherBookings(teacherId);
}

class UpdateBookingStatus extends UseCase<void, UpdateBookingStatusParams> {
  final BookingRepository repository;
  UpdateBookingStatus(this.repository);

  @override
  Future<void> call(UpdateBookingStatusParams params) =>
      repository.updateBookingStatus(params.bookingId, params.status,
          zoomLink: params.zoomLink);
}

class UpdateBookingStatusParams {
  final String bookingId;
  final String status;
  final String? zoomLink;

  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
    this.zoomLink,
  });
}

class GetAllBookings extends UseCase<List<BookingEntity>, NoParams> {
  final BookingRepository repository;
  GetAllBookings(this.repository);

  @override
  Future<List<BookingEntity>> call(NoParams params) => repository.getAllBookings();
}
