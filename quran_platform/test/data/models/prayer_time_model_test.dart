import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/data/models/prayer_time_model.dart';

void main() {
  group('PrayerTimeModel', () {
    test('fromJson parses Aladhan API response correctly', () {
      final json = {
        'timings': {
          'Fajr': '05:15 (MSK)',
          'Sunrise': '06:45 (MSK)',
          'Dhuhr': '12:30 (MSK)',
          'Asr': '15:45 (MSK)',
          'Maghrib': '18:20 (MSK)',
          'Isha': '19:50 (MSK)',
        },
        'date': {
          'readable': '15 Mar 2024',
        },
      };

      final model = PrayerTimeModel.fromJson(json);

      expect(model.fajr, '05:15');
      expect(model.sunrise, '06:45');
      expect(model.dhuhr, '12:30');
      expect(model.asr, '15:45');
      expect(model.maghrib, '18:20');
      expect(model.isha, '19:50');
      expect(model.date, '15 Mar 2024');
    });

    test('fromJson removes timezone info from times', () {
      final json = {
        'timings': {
          'Fajr': '04:30 (EET)',
          'Sunrise': '06:00 (EET)',
          'Dhuhr': '12:15 (EET)',
          'Asr': '15:30 (EET)',
          'Maghrib': '18:00 (EET)',
          'Isha': '19:30 (EET)',
        },
        'date': {
          'readable': '20 Jan 2024',
        },
      };

      final model = PrayerTimeModel.fromJson(json);

      expect(model.fajr, '04:30');
      expect(model.sunrise, '06:00');
      expect(model.isha, '19:30');
    });

    test('fromJson handles times without timezone', () {
      final json = {
        'timings': {
          'Fajr': '05:00',
          'Sunrise': '06:30',
          'Dhuhr': '12:00',
          'Asr': '15:00',
          'Maghrib': '18:00',
          'Isha': '19:30',
        },
        'date': {
          'readable': '01 Jan 2024',
        },
      };

      final model = PrayerTimeModel.fromJson(json);
      expect(model.fajr, '05:00');
    });

    test('fromJson handles missing fields gracefully', () {
      final json = {
        'timings': <String, dynamic>{},
        'date': <String, dynamic>{},
      };

      final model = PrayerTimeModel.fromJson(json);
      expect(model.fajr, '');
      expect(model.date, '');
    });

    test('toMap returns Russian prayer names', () {
      const model = PrayerTimeModel(
        fajr: '05:00', sunrise: '06:30', dhuhr: '12:00',
        asr: '15:00', maghrib: '18:00', isha: '19:30',
        date: 'test',
      );

      final map = model.toMap();
      expect(map.keys, containsAll(['Фаджр', 'Восход', 'Зухр', 'Аср', 'Магриб', 'Иша']));
    });
  });
}
