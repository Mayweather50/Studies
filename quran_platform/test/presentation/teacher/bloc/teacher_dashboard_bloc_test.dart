import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/domain/entities/booking_entity.dart';
import 'package:quran_platform/domain/usecases/booking_usecases.dart';
import 'package:quran_platform/presentation/teacher/bloc/teacher_dashboard_bloc.dart';

class MockGetTeacherBookings extends Mock implements GetTeacherBookings {}
class MockUpdateBookingStatus extends Mock implements UpdateBookingStatus {}

void main() {
  late TeacherDashboardBloc bloc;
  late MockGetTeacherBookings mockGetTeacherBookings;
  late MockUpdateBookingStatus mockUpdateBookingStatus;

  final pendingBooking = BookingEntity(
    id: 'b1', studentId: 's1', teacherId: 't1',
    studentName: 'Ахмад', teacherName: 'Устаз',
    date: DateTime.now().add(const Duration(days: 2)),
    timeSlot: '23:00', status: 'pending', discipline: 'Таджвид',
  );

  final confirmedBooking = BookingEntity(
    id: 'b2', studentId: 's2', teacherId: 't1',
    studentName: 'Мухаммад', teacherName: 'Устаз',
    date: DateTime.now().add(const Duration(days: 3)),
    timeSlot: '23:00', status: 'confirmed', discipline: 'Хифз',
    zoomLink: 'https://zoom.us/j/123',
  );

  final pastBooking = BookingEntity(
    id: 'b3', studentId: 's3', teacherId: 't1',
    studentName: 'Али', teacherName: 'Устаз',
    date: DateTime.now().subtract(const Duration(days: 5)),
    timeSlot: '00:00', status: 'completed', discipline: 'Тафсир',
  );

  setUpAll(() {
    registerFallbackValue(const UpdateBookingStatusParams(
      bookingId: '', status: '',
    ));
  });

  setUp(() {
    mockGetTeacherBookings = MockGetTeacherBookings();
    mockUpdateBookingStatus = MockUpdateBookingStatus();

    bloc = TeacherDashboardBloc(
      getTeacherBookings: mockGetTeacherBookings,
      updateBookingStatus: mockUpdateBookingStatus,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is TeacherDashboardInitial', () {
    expect(bloc.state, const TeacherDashboardInitial());
  });

  group('TeacherDashboardLoadRequested', () {
    blocTest<TeacherDashboardBloc, TeacherDashboardState>(
      'emits [Loading, Loaded] with bookings',
      build: () {
        when(() => mockGetTeacherBookings(any()))
            .thenAnswer((_) async => [pendingBooking, confirmedBooking, pastBooking]);
        return bloc;
      },
      act: (b) => b.add(const TeacherDashboardLoadRequested('t1')),
      expect: () => [
        const TeacherDashboardLoading(),
        isA<TeacherDashboardLoaded>()
            .having((s) => s.bookings, 'bookings', hasLength(3)),
      ],
    );

    blocTest<TeacherDashboardBloc, TeacherDashboardState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetTeacherBookings(any()))
            .thenThrow(Exception('Error'));
        return bloc;
      },
      act: (b) => b.add(const TeacherDashboardLoadRequested('t1')),
      expect: () => [
        const TeacherDashboardLoading(),
        isA<TeacherDashboardError>(),
      ],
    );
  });

  group('TeacherDashboardLoaded helpers', () {
    test('pendingBookings returns only pending', () {
      final state = TeacherDashboardLoaded(
        [pendingBooking, confirmedBooking, pastBooking],
      );
      expect(state.pendingBookings, [pendingBooking]);
    });

    test('upcomingBookings returns confirmed + upcoming', () {
      final state = TeacherDashboardLoaded(
        [pendingBooking, confirmedBooking, pastBooking],
      );
      expect(state.upcomingBookings, [confirmedBooking]);
    });
  });

  group('TeacherBookingActionRequested', () {
    blocTest<TeacherDashboardBloc, TeacherDashboardState>(
      'accepts booking and reloads',
      build: () {
        when(() => mockUpdateBookingStatus(any()))
            .thenAnswer((_) async {});
        when(() => mockGetTeacherBookings(any()))
            .thenAnswer((_) async => [confirmedBooking]);
        return bloc;
      },
      act: (b) => b.add(const TeacherBookingActionRequested(
        bookingId: 'b1',
        status: 'confirmed',
        zoomLink: 'https://zoom.us/j/new',
        teacherId: 't1',
      )),
      expect: () => [
        const TeacherDashboardLoading(),
        isA<TeacherDashboardLoaded>(),
      ],
      verify: (_) {
        final captured = verify(() => mockUpdateBookingStatus(captureAny())).captured;
        final params = captured.first as UpdateBookingStatusParams;
        expect(params.status, 'confirmed');
        expect(params.zoomLink, 'https://zoom.us/j/new');
      },
    );

    blocTest<TeacherDashboardBloc, TeacherDashboardState>(
      'declines booking and reloads',
      build: () {
        when(() => mockUpdateBookingStatus(any()))
            .thenAnswer((_) async {});
        when(() => mockGetTeacherBookings(any()))
            .thenAnswer((_) async => []);
        return bloc;
      },
      act: (b) => b.add(const TeacherBookingActionRequested(
        bookingId: 'b1',
        status: 'cancelled',
        teacherId: 't1',
      )),
      expect: () => [
        const TeacherDashboardLoading(),
        isA<TeacherDashboardLoaded>(),
      ],
    );
  });
}
