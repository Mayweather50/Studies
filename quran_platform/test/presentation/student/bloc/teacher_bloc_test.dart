import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/domain/entities/review_entity.dart';
import 'package:quran_platform/domain/entities/teacher_entity.dart';
import 'package:quran_platform/domain/usecases/review_usecases.dart';
import 'package:quran_platform/domain/usecases/teacher_usecases.dart';
import 'package:quran_platform/presentation/student/bloc/teacher_bloc.dart';

class MockGetTeacherById extends Mock implements GetTeacherById {}
class MockGetTeacherReviews extends Mock implements GetTeacherReviews {}

void main() {
  late TeacherBloc teacherBloc;
  late MockGetTeacherById mockGetTeacherById;
  late MockGetTeacherReviews mockGetTeacherReviews;

  const teacher = TeacherEntity(
    id: 't1',
    name: 'Устаз Ибрахим',
    bio: 'Опытный преподаватель',
    experience: '10 лет',
    disciplines: ['Таджвид', 'Хифз'],
    rating: 4.8,
    reviewCount: 5,
  );

  const reviews = [
    ReviewEntity(
      id: 'r1', studentId: 's1', teacherId: 't1',
      bookingId: 'b1', studentName: 'Ахмад',
      rating: 5, comment: 'Отлично!',
    ),
    ReviewEntity(
      id: 'r2', studentId: 's2', teacherId: 't1',
      bookingId: 'b2', studentName: 'Мухаммад',
      rating: 4, comment: 'Хорошо',
    ),
  ];

  setUp(() {
    mockGetTeacherById = MockGetTeacherById();
    mockGetTeacherReviews = MockGetTeacherReviews();

    teacherBloc = TeacherBloc(
      getTeacherById: mockGetTeacherById,
      getTeacherReviews: mockGetTeacherReviews,
    );
  });

  tearDown(() => teacherBloc.close());

  test('initial state is TeacherInitial', () {
    expect(teacherBloc.state, const TeacherInitial());
  });

  group('TeacherLoadRequested', () {
    blocTest<TeacherBloc, TeacherState>(
      'emits [TeacherLoading, TeacherLoaded] with teacher and reviews',
      build: () {
        when(() => mockGetTeacherById(any()))
            .thenAnswer((_) async => teacher);
        when(() => mockGetTeacherReviews(any()))
            .thenAnswer((_) async => reviews);
        return teacherBloc;
      },
      act: (bloc) => bloc.add(const TeacherLoadRequested('t1')),
      expect: () => [
        const TeacherLoading(),
        isA<TeacherLoaded>()
            .having((s) => s.teacher.name, 'name', 'Устаз Ибрахим')
            .having((s) => s.reviews, 'reviews', hasLength(2)),
      ],
    );

    blocTest<TeacherBloc, TeacherState>(
      'emits [TeacherLoading, TeacherError] when teacher not found',
      build: () {
        when(() => mockGetTeacherById(any()))
            .thenAnswer((_) async => null);
        return teacherBloc;
      },
      act: (bloc) => bloc.add(const TeacherLoadRequested('nonexistent')),
      expect: () => [
        const TeacherLoading(),
        isA<TeacherError>()
            .having((s) => s.message, 'message', contains('не найден')),
      ],
    );

    blocTest<TeacherBloc, TeacherState>(
      'emits [TeacherLoading, TeacherError] on exception',
      build: () {
        when(() => mockGetTeacherById(any()))
            .thenThrow(Exception('Server error'));
        return teacherBloc;
      },
      act: (bloc) => bloc.add(const TeacherLoadRequested('t1')),
      expect: () => [
        const TeacherLoading(),
        isA<TeacherError>(),
      ],
    );
  });
}
