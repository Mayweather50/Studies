import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/domain/entities/prayer_time_entity.dart';

void main() {
  group('PrayerTimeEntity', () {
    const prayerTime = PrayerTimeEntity(
      fajr: '05:15',
      sunrise: '06:45',
      dhuhr: '12:30',
      asr: '15:45',
      maghrib: '18:20',
      isha: '19:50',
      date: '15 Mar 2024',
    );

    test('creates entity with all fields', () {
      expect(prayerTime.fajr, '05:15');
      expect(prayerTime.sunrise, '06:45');
      expect(prayerTime.dhuhr, '12:30');
      expect(prayerTime.asr, '15:45');
      expect(prayerTime.maghrib, '18:20');
      expect(prayerTime.isha, '19:50');
      expect(prayerTime.date, '15 Mar 2024');
    });

    test('toMap returns correct map with Russian names', () {
      final map = prayerTime.toMap();

      expect(map, hasLength(6));
      expect(map['Фаджр'], '05:15');
      expect(map['Восход'], '06:45');
      expect(map['Зухр'], '12:30');
      expect(map['Аср'], '15:45');
      expect(map['Магриб'], '18:20');
      expect(map['Иша'], '19:50');
    });

    test('Equatable comparison works', () {
      const p1 = PrayerTimeEntity(
        fajr: '05:15', sunrise: '06:45', dhuhr: '12:30',
        asr: '15:45', maghrib: '18:20', isha: '19:50',
        date: '15 Mar 2024',
      );
      const p2 = PrayerTimeEntity(
        fajr: '05:15', sunrise: '06:45', dhuhr: '12:30',
        asr: '15:45', maghrib: '18:20', isha: '19:50',
        date: '15 Mar 2024',
      );

      expect(p1, equals(p2));
    });
  });
}
