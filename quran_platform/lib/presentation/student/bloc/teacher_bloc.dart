import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/review_entity.dart';
import '../../../domain/entities/teacher_entity.dart';
import '../../../domain/usecases/review_usecases.dart';
import '../../../domain/usecases/teacher_usecases.dart';

// ─── Events ───
abstract class TeacherEvent extends Equatable {
  const TeacherEvent();
  @override
  List<Object?> get props => [];
}

class TeacherLoadRequested extends TeacherEvent {
  final String teacherId;
  const TeacherLoadRequested(this.teacherId);
  @override
  List<Object?> get props => [teacherId];
}

// ─── States ───
abstract class TeacherState extends Equatable {
  const TeacherState();
  @override
  List<Object?> get props => [];
}

class TeacherInitial extends TeacherState {
  const TeacherInitial();
}

class TeacherLoading extends TeacherState {
  const TeacherLoading();
}

class TeacherLoaded extends TeacherState {
  final TeacherEntity teacher;
  final List<ReviewEntity> reviews;

  const TeacherLoaded({required this.teacher, required this.reviews});
  @override
  List<Object?> get props => [teacher, reviews];
}

class TeacherError extends TeacherState {
  final String message;
  const TeacherError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ───
class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final GetTeacherById getTeacherById;
  final GetTeacherReviews getTeacherReviews;

  TeacherBloc({
    required this.getTeacherById,
    required this.getTeacherReviews,
  }) : super(const TeacherInitial()) {
    on<TeacherLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
      TeacherLoadRequested event, Emitter<TeacherState> emit) async {
    emit(const TeacherLoading());
    try {
      final teacher = await getTeacherById(event.teacherId);
      if (teacher == null) {
        emit(const TeacherError('Учитель не найден'));
        return;
      }

      final reviews = await getTeacherReviews(event.teacherId);
      emit(TeacherLoaded(teacher: teacher, reviews: reviews));
    } catch (e) {
      emit(TeacherError(e.toString()));
    }
  }
}
