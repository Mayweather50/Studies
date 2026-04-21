import '../../domain/entities/prayer_time_entity.dart';

class PrayerTimeModel extends PrayerTimeEntity {
  const PrayerTimeModel({
    required super.fajr,
    required super.sunrise,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
    required super.date,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>;
    final dateInfo = json['date'] as Map<String, dynamic>;

    String cleanTime(String time) {
      // Remove timezone info like " (MSK)"
      return time.replaceAll(RegExp(r'\s*\(.*\)'), '');
    }

    return PrayerTimeModel(
      fajr: cleanTime(timings['Fajr'] ?? ''),
      sunrise: cleanTime(timings['Sunrise'] ?? ''),
      dhuhr: cleanTime(timings['Dhuhr'] ?? ''),
      asr: cleanTime(timings['Asr'] ?? ''),
      maghrib: cleanTime(timings['Maghrib'] ?? ''),
      isha: cleanTime(timings['Isha'] ?? ''),
      date: dateInfo['readable'] ?? '',
    );
  }
}
