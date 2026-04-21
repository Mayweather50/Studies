import 'package:equatable/equatable.dart';

class PrayerTimeEntity extends Equatable {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String date;

  const PrayerTimeEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  Map<String, String> toMap() => {
        'Фаджр': fajr,
        'Восход': sunrise,
        'Зухр': dhuhr,
        'Аср': asr,
        'Магриб': maghrib,
        'Иша': isha,
      };

  @override
  List<Object?> get props => [fajr, dhuhr, asr, maghrib, isha, date];
}
