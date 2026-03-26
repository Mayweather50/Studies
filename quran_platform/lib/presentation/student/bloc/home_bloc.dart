import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/prayer_time_entity.dart';
import '../../../domain/entities/teacher_entity.dart';
import '../../../domain/usecases/prayer_usecases.dart';
import '../../../domain/usecases/teacher_usecases.dart';

// ─── Events ───
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeLoadRequested extends HomeEvent {
  final double? latitude;
  final double? longitude;
  const HomeLoadRequested({this.latitude, this.longitude});
  @override
  List<Object?> get props => [latitude, longitude];
}

class HomeFilterChanged extends HomeEvent {
  final String? discipline;
  final String? ageGroup;
  final String? level;
  final String? searchQuery;

  const HomeFilterChanged({
    this.discipline,
    this.ageGroup,
    this.level,
    this.searchQuery,
  });
  @override
  List<Object?> get props => [discipline, ageGroup, level, searchQuery];
}

// ─── States ───
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<TeacherEntity> teachers;
  final PrayerTimeEntity? prayerTimes;
  final String? selectedDiscipline;
  final String? selectedAgeGroup;
  final String? selectedLevel;

  const HomeLoaded({
    required this.teachers,
    this.prayerTimes,
    this.selectedDiscipline,
    this.selectedAgeGroup,
    this.selectedLevel,
  });

  @override
  List<Object?> get props => [
        teachers,
        prayerTimes,
        selectedDiscipline,
        selectedAgeGroup,
        selectedLevel,
      ];

  HomeLoaded copyWith({
    List<TeacherEntity>? teachers,
    PrayerTimeEntity? prayerTimes,
    String? selectedDiscipline,
    String? selectedAgeGroup,
    String? selectedLevel,
  }) {
    return HomeLoaded(
      teachers: teachers ?? this.teachers,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      selectedDiscipline: selectedDiscipline,
      selectedAgeGroup: selectedAgeGroup,
      selectedLevel: selectedLevel,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── BLoC ───
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTeachers getTeachers;
  final GetPrayerTimes getPrayerTimes;

  HomeBloc({
    required this.getTeachers,
    required this.getPrayerTimes,
  }) : super(const HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeFilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoadRequested(
      HomeLoadRequested event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      final teachers = await getTeachers(const GetTeachersParams());

      PrayerTimeEntity? prayerTimes;
      if (event.latitude != null && event.longitude != null) {
        try {
          prayerTimes = await getPrayerTimes(
            PrayerTimesParams(
              latitude: event.latitude!,
              longitude: event.longitude!,
            ),
          );
        } catch (_) {
          // Prayer times are optional
        }
      }

      emit(HomeLoaded(teachers: teachers, prayerTimes: prayerTimes));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onFilterChanged(
      HomeFilterChanged event, Emitter<HomeState> emit) async {
    final currentState = state;
    PrayerTimeEntity? prayerTimes;
    if (currentState is HomeLoaded) {
      prayerTimes = currentState.prayerTimes;
    }

    emit(const HomeLoading());
    try {
      final teachers = await getTeachers(
        GetTeachersParams(
          discipline: event.discipline,
          ageGroup: event.ageGroup,
          level: event.level,
          searchQuery: event.searchQuery,
        ),
      );

      emit(HomeLoaded(
        teachers: teachers,
        prayerTimes: prayerTimes,
        selectedDiscipline: event.discipline,
        selectedAgeGroup: event.ageGroup,
        selectedLevel: event.level,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
