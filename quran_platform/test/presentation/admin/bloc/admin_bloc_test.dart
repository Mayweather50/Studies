import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/core/usecases/usecase.dart';
import 'package:quran_platform/domain/entities/booking_entity.dart';
import 'package:quran_platform/domain/entities/teacher_entity.dart';
import 'package:quran_platform/domain/usecases/booking_usecases.dart';
import 'package:quran_platform/domain/usecases/teacher_usecases.dart';
import 'package:quran_platform/presentation/admin/bloc/admin_bloc.dart';

class MockGetTeachers extends Mock implements GetTeachers {}
class MockCreateTeacher extends Mock implements CreateTeacher {}
class MockUpdateTeacher extends Mock implements UpdateTeacher {}
class MockDeleteTeacher extends Mock implements DeleteTeacher {}
class MockGetAllBookings extends Mock implements GetAllBookings {}

void main() {
  late AdminBloc adminBloc;
  late MockGetTeachers mockGetTeachers;
  late MockCreateTeacher mockCreateTeacher;
  late MockUpdateTeacher mockUpdateTeacher;
  late MockDeleteTeacher mockDeleteTeacher;
  late MockGetAllBookings mockGetAllBookings;

  const teachers = [
    TeacherEntity(
      id: 't1', name: 'Устаз 1', bio: 'Bio', experience: '5 лет',
      disciplines: ['Таджвид'], isActive: true,
    ),
    TeacherEntity(
      id: 't2', name: 'Устаз 2', bio: 'Bio', experience: '3 года',
      disciplines: ['Хифз'], isActive: true,
    ),
  ];

  final bookings = [
    BookingEntity(
      id: 'b1', studentId: 's1', teacherId: 't1',
      studentName: 'Ахмад', teacherName: 'Устаз 1',
      date: DateTime(2024, 6, 15), timeSlot: '10:00',
      status: 'confirmed', discipline: 'Таджвид',
    ),
    BookingEntity(
      id: 'b2', studentId: 's2', teacherId: 't1',
      studentName: 'Мухаммад', teacherName: 'Устаз 1',
      date: DateTime(2024, 6, 16), timeSlot: '11:00',
      status: 'pending', discipline: 'Хифз',
    ),
    BookingEntity(
      id: 'b3', studentId: 's1', teacherId: 't2',
      studentName: 'Ахмад', teacherName: 'Устаз 2',
      date: DateTime(2024, 6, 17), timeSlot: '12:00',
      status: 'cancelled', discipline: 'Тафсир',
    ),
  ];

  const newTeacher = TeacherEntity(
    id: '', name: 'Новый', bio: 'Описание', experience: '1 год',
    disciplines: ['Таджвид'],
  );

  setUpAll(() {
    registerFallbackValue(const GetTeachersParams());
    registerFallbackValue(const NoParams());
    registerFallbackValue(newTeacher);
    registerFallbackValue('');
  });

  setUp(() {
    mockGetTeachers = MockGetTeachers();
    mockCreateTeacher = MockCreateTeacher();
    mockUpdateTeacher = MockUpdateTeacher();
    mockDeleteTeacher = MockDeleteTeacher();
    mockGetAllBookings = MockGetAllBookings();

    adminBloc = AdminBloc(
      getTeachers: mockGetTeachers,
      createTeacher: mockCreateTeacher,
      updateTeacher: mockUpdateTeacher,
      deleteTeacher: mockDeleteTeacher,
      getAllBookings: mockGetAllBookings,
    );
  });

  tearDown(() => adminBloc.close());

  test('initial state is AdminInitial', () {
    expect(adminBloc.state, const AdminInitial());
  });

  group('AdminLoadRequested', () {
    blocTest<AdminBloc, AdminState>(
      'emits [AdminLoading, AdminLoaded] with statistics',
      build: () {
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => teachers);
        when(() => mockGetAllBookings(any()))
            .thenAnswer((_) async => bookings);
        return adminBloc;
      },
      act: (bloc) => bloc.add(const AdminLoadRequested()),
      expect: () => [
        const AdminLoading(),
        isA<AdminLoaded>()
            .having((s) => s.teachers, 'teachers', hasLength(2))
            .having((s) => s.bookings, 'bookings', hasLength(3))
            .having((s) => s.totalStudents, 'students', 2) // s1 and s2
            .having((s) => s.totalLessons, 'lessons', 3),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'emits [AdminLoading, AdminError] on failure',
      build: () {
        when(() => mockGetTeachers(any()))
            .thenThrow(Exception('Error'));
        return adminBloc;
      },
      act: (bloc) => bloc.add(const AdminLoadRequested()),
      expect: () => [
        const AdminLoading(),
        isA<AdminError>(),
      ],
    );
  });

  group('AdminTeacherCreateRequested', () {
    blocTest<AdminBloc, AdminState>(
      'emits [AdminLoading, AdminTeacherSaved, ...] on success',
      build: () {
        when(() => mockCreateTeacher(any()))
            .thenAnswer((_) async {});
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => [...teachers, newTeacher]);
        when(() => mockGetAllBookings(any()))
            .thenAnswer((_) async => bookings);
        return adminBloc;
      },
      act: (bloc) => bloc.add(const AdminTeacherCreateRequested(newTeacher)),
      expect: () => [
        const AdminLoading(),
        const AdminTeacherSaved(),
        const AdminLoading(),
        isA<AdminLoaded>()
            .having((s) => s.teachers, 'teachers', hasLength(3)),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'emits [AdminLoading, AdminError] on failure',
      build: () {
        when(() => mockCreateTeacher(any()))
            .thenThrow(Exception('Create failed'));
        return adminBloc;
      },
      act: (bloc) => bloc.add(const AdminTeacherCreateRequested(newTeacher)),
      expect: () => [
        const AdminLoading(),
        isA<AdminError>(),
      ],
    );
  });

  group('AdminTeacherUpdateRequested', () {
    const updatedTeacher = TeacherEntity(
      id: 't1', name: 'Обновлённый', bio: 'Новое описание',
      experience: '7 лет', disciplines: ['Таджвид', 'Хифз'],
    );

    blocTest<AdminBloc, AdminState>(
      'emits [AdminLoading, AdminTeacherSaved, ...] on success',
      build: () {
        when(() => mockUpdateTeacher(any()))
            .thenAnswer((_) async {});
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => teachers);
        when(() => mockGetAllBookings(any()))
            .thenAnswer((_) async => bookings);
        return adminBloc;
      },
      act: (bloc) => bloc.add(const AdminTeacherUpdateRequested(updatedTeacher)),
      expect: () => [
        const AdminLoading(),
        const AdminTeacherSaved(),
        const AdminLoading(),
        isA<AdminLoaded>(),
      ],
    );
  });

  group('AdminTeacherDeleteRequested', () {
    blocTest<AdminBloc, AdminState>(
      'emits [AdminLoading, AdminTeacherDeleted, ...] on success',
      build: () {
        when(() => mockDeleteTeacher(any()))
            .thenAnswer((_) async {});
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => [teachers[1]]);
        when(() => mockGetAllBookings(any()))
            .thenAnswer((_) async => bookings);
        return adminBloc;
      },
      act: (bloc) => bloc.add(const AdminTeacherDeleteRequested('t1')),
      expect: () => [
        const AdminLoading(),
        const AdminTeacherDeleted(),
        const AdminLoading(),
        isA<AdminLoaded>()
            .having((s) => s.teachers, 'teachers', hasLength(1)),
      ],
    );
  });
}
