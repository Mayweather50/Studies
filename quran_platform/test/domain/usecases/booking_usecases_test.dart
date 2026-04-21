import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/core/usecases/usecase.dart';
import 'package:quran_platform/domain/entities/booking_entity.dart';
import 'package:quran_platform/domain/repositories/booking_repository.dart';
import 'package:quran_platform/domain/usecases/booking_usecases.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late MockBookingRepository mockRepo;

  final testBooking = BookingEntity(
    id: 'b1',
    studentId: 's1',
    teacherId: 't1',
    studentName: 'Ахмад',
    teacherName: 'Устаз Мухаммад',
    date: DateTime(2026, 5, 1),
    timeSlot: '10:00',
    status: 'pending',
    discipline: 'Таджвид',
  );

  final testBooking2 = BookingEntity(
    id: 'b2',
    studentId: 's1',
    teacherId: 't2',
    studentName: 'Ахмад',
    teacherName: 'Устаз Ибрахим',
    date: DateTime(2026, 5, 2),
    timeSlot: '14:00',
    status: 'confirmed',
    discipline: 'Хифз',
  );

  setUp(() {
    mockRepo = MockBookingRepository();
  });

  setUpAll(() {
    registerFallbackValue(testBooking);
  });

  group('CreateBooking', () {
    test('calls repository.createBooking', () async {
      when(() => mockRepo.createBooking(any()))
          .thenAnswer((_) async {});

      final useCase = CreateBooking(mockRepo);
      await useCase(testBooking);

      verify(() => mockRepo.createBooking(testBooking)).called(1);
    });
  });

  group('GetStudentBookings', () {
    test('returns student bookings', () async {
      when(() => mockRepo.getStudentBookings('s1'))
          .thenAnswer((_) async => [testBooking, testBooking2]);

      final useCase = GetStudentBookings(mockRepo);
      final result = await useCase('s1');

      expect(result.length, 2);
      expect(result.first.studentId, 's1');
      verify(() => mockRepo.getStudentBookings('s1')).called(1);
    });

    test('returns empty list for student with no bookings', () async {
      when(() => mockRepo.getStudentBookings('s_none'))
          .thenAnswer((_) async => []);

      final useCase = GetStudentBookings(mockRepo);
      final result = await useCase('s_none');

      expect(result, isEmpty);
    });
  });

  group('GetTeacherBookings', () {
    test('returns teacher bookings', () async {
      when(() => mockRepo.getTeacherBookings('t1'))
          .thenAnswer((_) async => [testBooking]);

      final useCase = GetTeacherBookings(mockRepo);
      final result = await useCase('t1');

      expect(result.length, 1);
      expect(result.first.teacherId, 't1');
      verify(() => mockRepo.getTeacherBookings('t1')).called(1);
    });
  });

  group('UpdateBookingStatus', () {
    test('updates status without zoom link', () async {
      when(() => mockRepo.updateBookingStatus('b1', 'confirmed'))
          .thenAnswer((_) async {});

      final useCase = UpdateBookingStatus(mockRepo);
      await useCase(const UpdateBookingStatusParams(
        bookingId: 'b1',
        status: 'confirmed',
      ));

      verify(() => mockRepo.updateBookingStatus('b1', 'confirmed')).called(1);
    });

    test('updates status with zoom link', () async {
      when(() => mockRepo.updateBookingStatus(
            'b1',
            'confirmed',
            zoomLink: 'https://zoom.us/j/123',
          )).thenAnswer((_) async {});

      final useCase = UpdateBookingStatus(mockRepo);
      await useCase(const UpdateBookingStatusParams(
        bookingId: 'b1',
        status: 'confirmed',
        zoomLink: 'https://zoom.us/j/123',
      ));

      verify(() => mockRepo.updateBookingStatus(
            'b1',
            'confirmed',
            zoomLink: 'https://zoom.us/j/123',
          )).called(1);
    });

    test('cancels booking', () async {
      when(() => mockRepo.updateBookingStatus('b1', 'cancelled'))
          .thenAnswer((_) async {});

      final useCase = UpdateBookingStatus(mockRepo);
      await useCase(const UpdateBookingStatusParams(
        bookingId: 'b1',
        status: 'cancelled',
      ));

      verify(() => mockRepo.updateBookingStatus('b1', 'cancelled')).called(1);
    });
  });

  group('GetAllBookings', () {
    test('returns all bookings', () async {
      when(() => mockRepo.getAllBookings())
          .thenAnswer((_) async => [testBooking, testBooking2]);

      final useCase = GetAllBookings(mockRepo);
      final result = await useCase(const NoParams());

      expect(result.length, 2);
      verify(() => mockRepo.getAllBookings()).called(1);
    });

    test('returns empty list when no bookings exist', () async {
      when(() => mockRepo.getAllBookings())
          .thenAnswer((_) async => []);

      final useCase = GetAllBookings(mockRepo);
      final result = await useCase(const NoParams());

      expect(result, isEmpty);
    });
  });
}
