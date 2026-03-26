import '../entities/prayer_time_entity.dart';
import '../repositories/prayer_repository.dart';
import '../../core/usecases/usecase.dart';

class GetPrayerTimes extends UseCase<PrayerTimeEntity, PrayerTimesParams> {
  final PrayerRepository repository;
  GetPrayerTimes(this.repository);

  @override
  Future<PrayerTimeEntity> call(PrayerTimesParams params) =>
      repository.getPrayerTimes(params.latitude, params.longitude);
}

class PrayerTimesParams {
  final double latitude;
  final double longitude;

  const PrayerTimesParams({required this.latitude, required this.longitude});
}
