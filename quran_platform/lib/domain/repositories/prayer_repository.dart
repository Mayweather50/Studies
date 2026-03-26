import '../entities/prayer_time_entity.dart';

abstract class PrayerRepository {
  Future<PrayerTimeEntity> getPrayerTimes(double latitude, double longitude);
}
