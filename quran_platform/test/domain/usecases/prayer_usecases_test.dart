import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/domain/entities/prayer_time_entity.dart';
import 'package:quran_platform/domain/repositories/prayer_repository.dart';
import 'package:quran_platform/domain/usecases/prayer_usecases.dart';

class MockPrayerRepository extends Mock implements PrayerRepository {}

void main() {
  late MockPrayerRepository mockRepo;

  const testPrayerTimes = PrayerTimeEntity(
    fajr: '04:30',
    sunrise: '06:00',
    dhuhr: '12:45',
    asr: '16:15',
    maghrib: '19:30',
    isha: '21:00',
    date: '15 Apr 2026',
  );

  setUp(() {
    mockRepo = MockPrayerRepository();
  });

  group('GetPrayerTimes', () {
    test('returns prayer times for given coordinates', () async {
      when(() => mockRepo.getPrayerTimes(42.97, 47.50))
          .thenAnswer((_) async => testPrayerTimes);

      final useCase = GetPrayerTimes(mockRepo);
      final result = await useCase(
        const PrayerTimesParams(latitude: 42.97, longitude: 47.50),
      );

      expect(result, testPrayerTimes);
      expect(result.fajr, '04:30');
      expect(result.dhuhr, '12:45');
      expect(result.maghrib, '19:30');
      verify(() => mockRepo.getPrayerTimes(42.97, 47.50)).called(1);
    });

    test('returns prayer times for different location', () async {
      const moscowTimes = PrayerTimeEntity(
        fajr: '03:15',
        sunrise: '05:30',
        dhuhr: '13:00',
        asr: '17:00',
        maghrib: '20:45',
        isha: '22:30',
        date: '15 Apr 2026',
      );

      when(() => mockRepo.getPrayerTimes(55.75, 37.62))
          .thenAnswer((_) async => moscowTimes);

      final useCase = GetPrayerTimes(mockRepo);
      final result = await useCase(
        const PrayerTimesParams(latitude: 55.75, longitude: 37.62),
      );

      expect(result, moscowTimes);
      expect(result.fajr, '03:15');
    });

    test('throws exception on API failure', () async {
      when(() => mockRepo.getPrayerTimes(any(), any()))
          .thenThrow(Exception('Нет подключения к интернету'));

      final useCase = GetPrayerTimes(mockRepo);

      expect(
        () => useCase(const PrayerTimesParams(latitude: 0, longitude: 0)),
        throwsException,
      );
    });
  });
}
