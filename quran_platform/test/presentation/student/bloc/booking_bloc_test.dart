import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/domain/entities/booking_entity.dart';
import 'package:quran_platform/domain/usecases/booking_usecases.dart';
import 'package:quran_platform/presentation/student/bloc/booking_bloc.dart';

class MockCreateBooking extends Mock implements CreateBooking {}
class MockGetStudentBookings extends Mock implements GetStudentBookings {}
class MockGetTeacherBookings extends Mock implements GetTeacherBookings {}
class MockUpdateBookingStatus extends Mock implements UpdateBookingStatus {}

void main() {
  late BookingBloc bookingBloc;
  late MockCreateBooking mockCreateBooking;
  late MockGetStudentBookings mockGetStudentBookings;
  late MockGetTeacherBookings mockGetTeacherBookings;
  late MockUpdateBookingStatus mockUpdateBookingStatus;

  final testBooking = BookingEntity(
    id: 'b1',
    studentId: 's1',
    teacherId: 't1',
    studentName: 'Ахмад',
    teacherName: 'Устаз',
    date: DateTime(2024, 6, 15),
    timeSlot: '10:00',
    status: 'pending',
    discipline: 'Таджвид',
  );

  final confirmedBooking = BookingEntity(
    id: 'b2',
    studentId: 's1',
    teacherId: 't1',
    studentName: 'Ахмад',
    teacherName: 'Устаз',
    date: DateTime.now().add(const Duration(days: 3)),
    timeSlot: '23:00',
    status: 'confirmed',
    discipline: 'Хифз',
    zoomLink: 'https://zoom.us/j/123',
  );

  final pastBooking = BookingEntity(
    id: 'b3',
    studentId: 's1',
    teacherId: 't1',
    studentName: 'Ахмад',
    teacherName: 'Устаз',
    date: DateTime.now().subtract(const Duration(days: 5)),
    timeSlot: '00:00',
    status: 'completed',
    discipline: 'Тафсир',
  );

  setUpAll(() {
    registerFallbackValue(testBooking);
    registerFallbackValue(const UpdateBookingStatusParams(
      bookingId: '', status: '',
    ));
  });

  setUp(() {
    mockCreateBooking = MockCreateBooking();
    mockGetStudentBookings = MockGetStudentBookings();
    mockGetTeacherBookings = MockGetTeacherBookings();
    mockUpdateBookingStatus = MockUpdateBookingStatus();

    bookingBloc = BookingBloc(
      createBooking: mockCreateBooking,
      getStudentBookings: mockGetStudentBookings,
      getTeacherBookings: mockGetTeacherBookings,
      updateBookingStatus: mockUpdateBookingStatus,
    );
  });

  tearDown(() => bookingBloc.close());

  test('initial state is BookingInitial', () {
    expect(bookingBloc.state, const BookingInitial());
  });

  group('BookingCreateRequested', () {
    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingCreated] on success',
      build: () {
        when(() => mockCreateBooking(any()))
            .thenAnswer((_) async {});
        return bookingBloc;
      },
      act: (bloc) => bloc.add(BookingCreateRequested(testBooking)),
      expect: () => [
        const BookingLoading(),
        const BookingCreated(),
      ],
    );

    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingError] on failure',
      build: () {
        when(() => mockCreateBooking(any()))
            .thenThrow(Exception('Slot taken'));
        return bookingBloc;
      },
      act: (bloc) => bloc.add(BookingCreateRequested(testBooking)),
      expect: () => [
        const BookingLoading(),
        isA<BookingError>(),
      ],
    );
  });

  group('BookingStudentLoadRequested', () {
    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingsLoaded] with student bookings',
      build: () {
        when(() => mockGetStudentBookings(any()))
            .thenAnswer((_) async => [testBooking, confirmedBooking, pastBooking]);
        return bookingBloc;
      },
      act: (bloc) => bloc.add(const BookingStudentLoadRequested('s1')),
      expect: () => [
        const BookingLoading(),
        isA<BookingsLoaded>()
            .having((s) => s.bookings, 'bookings', hasLength(3)),
      ],
    );

    blocTest<BookingBloc, BookingState>(
      'emits empty BookingsLoaded when no bookings',
      build: () {
        when(() => mockGetStudentBookings(any()))
            .thenAnswer((_) async => []);
        return bookingBloc;
      },
      act: (bloc) => bloc.add(const BookingStudentLoadRequested('s1')),
      expect: () => [
        const BookingLoading(),
        isA<BookingsLoaded>()
            .having((s) => s.bookings, 'bookings', isEmpty),
      ],
    );
  });

  group('BookingsLoaded helpers', () {
    test('upcoming filters correctly', () {
      final state = BookingsLoaded([testBooking, confirmedBooking, pastBooking]);
      // confirmedBooking has future date + confirmed status = upcoming
      expect(state.upcoming, contains(confirmedBooking));
      expect(state.upcoming, isNot(contains(pastBooking)));
    });

    test('past filters correctly', () {
      final state = BookingsLoaded([confirmedBooking, pastBooking]);
      expect(state.past, contains(pastBooking));
    });

    test('pending filters correctly', () {
      final state = BookingsLoaded([testBooking, confirmedBooking]);
      expect(state.pending, contains(testBooking));
      expect(state.pending, isNot(contains(confirmedBooking)));
    });
  });

  group('BookingStatusUpdateRequested', () {
    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingStatusUpdated] on success',
      build: () {
        when(() => mockUpdateBookingStatus(any()))
            .thenAnswer((_) async {});
        return bookingBloc;
      },
      act: (bloc) => bloc.add(const BookingStatusUpdateRequested(
        bookingId: 'b1', status: 'cancelled',
      )),
      expect: () => [
        const BookingLoading(),
        const BookingStatusUpdated(),
      ],
    );

    blocTest<BookingBloc, BookingState>(
      'passes zoom link to use case',
      build: () {
        when(() => mockUpdateBookingStatus(any()))
            .thenAnswer((_) async {});
        return bookingBloc;
      },
      act: (bloc) => bloc.add(const BookingStatusUpdateRequested(
        bookingId: 'b1', status: 'confirmed',
        zoomLink: 'https://zoom.us/j/456',
      )),
      verify: (_) {
        final captured = verify(() => mockUpdateBookingStatus(captureAny())).captured;
        final params = captured.first as UpdateBookingStatusParams;
        expect(params.bookingId, 'b1');
        expect(params.status, 'confirmed');
        expect(params.zoomLink, 'https://zoom.us/j/456');
      },
    );
  });
}
