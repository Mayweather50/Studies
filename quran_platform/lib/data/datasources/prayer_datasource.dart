import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/prayer_time_model.dart';

abstract class PrayerDataSource {
  Future<PrayerTimeModel> getPrayerTimes(double latitude, double longitude);
}

class PrayerDataSourceImpl implements PrayerDataSource {
  @override
  Future<PrayerTimeModel> getPrayerTimes(
      double latitude, double longitude) async {
    try {
      final now = DateTime.now();
      final url = Uri.parse(
        '${AppConstants.aladhanBaseUrl}/timings/${now.day}-${now.month}-${now.year}'
        '?latitude=$latitude&longitude=$longitude&method=2',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PrayerTimeModel.fromJson(json['data']);
      } else {
        throw const ServerException('Ошибка загрузки времени намаза');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Ошибка сети: $e');
    }
  }
}
