import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/booking_entity.dart';
import '../../../domain/usecases/booking_usecases.dart';

// ─── Events ───
abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class BookingCreateRequested extends BookingEvent {
  final BookingEntity booking;
  const BookingCreateRequested(this.booking);
  @override
  List<Object?> get props => [booking];
}

class BookingStudentLoadRequested extends BookingEvent {
  final String studentId;
  const BookingStudentLoadRequested(this.studentId);
  @override
  List<Object?> get props => [studentId];
}

class BookingTeacherLoadRequested extends BookingEvent {
  final String teacherId;
  const BookingTeacherLoadRequested(this.teacherId);
  @override
  List<Object?> get props => [teacherId];
}

class BookingStatusUpdateRequested extends BookingEvent {
  final String bookingId;
  final String status;
  final String? zoomLink;

  const BookingStatusUpdateRequested({
    required this.bookingId,
    required this.status,
    this.zoomLink,
  });
  @override
  List<Object?> get props => [bookingId, status, zoomLink];
}

// ─── States ───
abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingCreated extends BookingState {
  const BookingCreated();
}

class BookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  const BookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];

  List<BookingEntity> get upcoming =>
      bookings.where((b) => b.isUpcoming).toList();

  List<BookingEntity> get past =>
      bookings.where((b) => !b.isUpcoming).toList();

  List<BookingEntity> get pending =>
      bookings.where((b) => b.isPending).toList();
}

class BookingStatusUpdated extends BookingState {
  const BookingStatusUpdated();
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ───
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBooking createBooking;
  final GetStudentBookings getStudentBookings;
  final GetTeacherBookings getTeacherBookings;
  final UpdateBookingStatus updateBookingStatus;

  BookingBloc({
    required this.createBooking,
    required this.getStudentBookings,
    required this.getTeacherBookings,
    required this.updateBookingStatus,
  }) : super(const BookingInitial()) {
    on<BookingCreateRequested>(_onCreateBooking);
    on<BookingStudentLoadRequested>(_onLoadStudentBookings);
    on<BookingTeacherLoadRequested>(_onLoadTeacherBookings);
    on<BookingStatusUpdateRequested>(_onUpdateStatus);
  }

  Future<void> _onCreateBooking(
      BookingCreateRequested event, Emitter<BookingState> emit) async {
    emit(const BookingLoading());
    try {
      await createBooking(event.booking);
      emit(const BookingCreated());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onLoadStudentBookings(
      BookingStudentLoadRequested event, Emitter<BookingState> emit) async {
    emit(const BookingLoading());
    try {
      final bookings = await getStudentBookings(event.studentId);
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onLoadTeacherBookings(
      BookingTeacherLoadRequested event, Emitter<BookingState> emit) async {
    emit(const BookingLoading());
    try {
      final bookings = await getTeacherBookings(event.teacherId);
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onUpdateStatus(
      BookingStatusUpdateRequested event, Emitter<BookingState> emit) async {
    emit(const BookingLoading());
    try {
      await updateBookingStatus(
        UpdateBookingStatusParams(
          bookingId: event.bookingId,
          status: event.status,
          zoomLink: event.zoomLink,
        ),
      );
      emit(const BookingStatusUpdated());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
