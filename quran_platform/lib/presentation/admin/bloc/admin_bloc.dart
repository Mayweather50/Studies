import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../../domain/entities/teacher_entity.dart';
import '../../../domain/usecases/booking_usecases.dart';
import '../../../domain/usecases/teacher_usecases.dart';

// ─── Events ───
abstract class AdminEvent extends Equatable {
  const AdminEvent();
  @override
  List<Object?> get props => [];
}

class AdminLoadRequested extends AdminEvent {
  const AdminLoadRequested();
}

class AdminTeacherCreateRequested extends AdminEvent {
  final TeacherEntity teacher;
  const AdminTeacherCreateRequested(this.teacher);
  @override
  List<Object?> get props => [teacher];
}

class AdminTeacherUpdateRequested extends AdminEvent {
  final TeacherEntity teacher;
  const AdminTeacherUpdateRequested(this.teacher);
  @override
  List<Object?> get props => [teacher];
}

class AdminTeacherDeleteRequested extends AdminEvent {
  final String teacherId;
  const AdminTeacherDeleteRequested(this.teacherId);
  @override
  List<Object?> get props => [teacherId];
}

// ─── States ───
abstract class AdminState extends Equatable {
  const AdminState();
  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminLoaded extends AdminState {
  final List<TeacherEntity> teachers;
  final List<BookingEntity> bookings;
  final int totalStudents;
  final int totalLessons;

  const AdminLoaded({
    required this.teachers,
    required this.bookings,
    this.totalStudents = 0,
    this.totalLessons = 0,
  });

  @override
  List<Object?> get props => [teachers, bookings, totalStudents, totalLessons];
}

class AdminTeacherSaved extends AdminState {
  const AdminTeacherSaved();
}

class AdminTeacherDeleted extends AdminState {
  const AdminTeacherDeleted();
}

class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ───
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetTeachers getTeachers;
  final CreateTeacher createTeacher;
  final UpdateTeacher updateTeacher;
  final DeleteTeacher deleteTeacher;
  final GetAllBookings getAllBookings;

  AdminBloc({
    required this.getTeachers,
    required this.createTeacher,
    required this.updateTeacher,
    required this.deleteTeacher,
    required this.getAllBookings,
  }) : super(const AdminInitial()) {
    on<AdminLoadRequested>(_onLoadRequested);
    on<AdminTeacherCreateRequested>(_onCreateTeacher);
    on<AdminTeacherUpdateRequested>(_onUpdateTeacher);
    on<AdminTeacherDeleteRequested>(_onDeleteTeacher);
  }

  Future<void> _onLoadRequested(
      AdminLoadRequested event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      final teachers = await getTeachers(const GetTeachersParams());
      final bookings = await getAllBookings(const NoParams());

      final uniqueStudents =
          bookings.map((b) => b.studentId).toSet().length;

      emit(AdminLoaded(
        teachers: teachers,
        bookings: bookings,
        totalStudents: uniqueStudents,
        totalLessons: bookings.length,
      ));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onCreateTeacher(
      AdminTeacherCreateRequested event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      await createTeacher(event.teacher);
      emit(const AdminTeacherSaved());
      add(const AdminLoadRequested());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onUpdateTeacher(
      AdminTeacherUpdateRequested event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      await updateTeacher(event.teacher);
      emit(const AdminTeacherSaved());
      add(const AdminLoadRequested());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onDeleteTeacher(
      AdminTeacherDeleteRequested event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      await deleteTeacher(event.teacherId);
      emit(const AdminTeacherDeleted());
      add(const AdminLoadRequested());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
