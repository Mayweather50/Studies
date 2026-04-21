import '../../domain/entities/prayer_time_entity.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_datasource.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerDataSource _dataSource;

  PrayerRepositoryImpl(this._dataSource);

  @override
  Future<PrayerTimeEntity> getPrayerTimes(double latitude, double longitude) =>
      _dataSource.getPrayerTimes(latitude, longitude);
}
