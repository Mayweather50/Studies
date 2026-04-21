import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/booking_entity.dart';
import '../../../domain/usecases/booking_usecases.dart';

// ─── Events ───
abstract class TeacherDashboardEvent extends Equatable {
  const TeacherDashboardEvent();
  @override
  List<Object?> get props => [];
}

class TeacherDashboardLoadRequested extends TeacherDashboardEvent {
  final String teacherId;
  const TeacherDashboardLoadRequested(this.teacherId);
  @override
  List<Object?> get props => [teacherId];
}

class TeacherBookingActionRequested extends TeacherDashboardEvent {
  final String bookingId;
  final String status;
  final String? zoomLink;
  final String teacherId;

  const TeacherBookingActionRequested({
    required this.bookingId,
    required this.status,
    this.zoomLink,
    required this.teacherId,
  });
  @override
  List<Object?> get props => [bookingId, status, zoomLink, teacherId];
}

// ─── States ───
abstract class TeacherDashboardState extends Equatable {
  const TeacherDashboardState();
  @override
  List<Object?> get props => [];
}

class TeacherDashboardInitial extends TeacherDashboardState {
  const TeacherDashboardInitial();
}

class TeacherDashboardLoading extends TeacherDashboardState {
  const TeacherDashboardLoading();
}

class TeacherDashboardLoaded extends TeacherDashboardState {
  final List<BookingEntity> bookings;

  const TeacherDashboardLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];

  List<BookingEntity> get pendingBookings =>
      bookings.where((b) => b.isPending).toList();

  List<BookingEntity> get upcomingBookings =>
      bookings.where((b) => b.isConfirmed && b.isUpcoming).toList();

  List<BookingEntity> get pastBookings =>
      bookings.where((b) => !b.isUpcoming || b.isCompleted).toList();
}

class TeacherDashboardError extends TeacherDashboardState {
  final String message;
  const TeacherDashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ───
class TeacherDashboardBloc
    extends Bloc<TeacherDashboardEvent, TeacherDashboardState> {
  final GetTeacherBookings getTeacherBookings;
  final UpdateBookingStatus updateBookingStatus;

  TeacherDashboardBloc({
    required this.getTeacherBookings,
    required this.updateBookingStatus,
  }) : super(const TeacherDashboardInitial()) {
    on<TeacherDashboardLoadRequested>(_onLoadRequested);
    on<TeacherBookingActionRequested>(_onBookingAction);
  }

  Future<void> _onLoadRequested(
      TeacherDashboardLoadRequested event,
      Emitter<TeacherDashboardState> emit) async {
    emit(const TeacherDashboardLoading());
    try {
      final bookings = await getTeacherBookings(event.teacherId);
      emit(TeacherDashboardLoaded(bookings));
    } catch (e) {
      emit(TeacherDashboardError(e.toString()));
    }
  }

  Future<void> _onBookingAction(
      TeacherBookingActionRequested event,
      Emitter<TeacherDashboardState> emit) async {
    try {
      await updateBookingStatus(
        UpdateBookingStatusParams(
          bookingId: event.bookingId,
          status: event.status,
          zoomLink: event.zoomLink,
        ),
      );
      // Reload bookings after action
      add(TeacherDashboardLoadRequested(event.teacherId));
    } catch (e) {
      emit(TeacherDashboardError(e.toString()));
    }
  }
}
