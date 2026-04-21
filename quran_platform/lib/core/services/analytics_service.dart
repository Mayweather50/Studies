import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ─── Авторизация ───

  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  Future<void> setUser(String userId, {String? role}) async {
    await _analytics.setUserId(id: userId);
    if (role != null) {
      await _analytics.setUserProperty(name: 'role', value: role);
    }
  }

  Future<void> clearUser() async {
    await _analytics.setUserId(id: null);
  }

  // ─── Бронирование уроков ───

  Future<void> logBookingCreated({
    required String teacherId,
    required String discipline,
  }) async {
    await _analytics.logEvent(
      name: 'booking_created',
      parameters: {
        'teacher_id': teacherId,
        'discipline': discipline,
      },
    );
  }

  Future<void> logBookingStatusChanged({
    required String bookingId,
    required String newStatus,
  }) async {
    await _analytics.logEvent(
      name: 'booking_status_changed',
      parameters: {
        'booking_id': bookingId,
        'new_status': newStatus,
      },
    );
  }

  // ─── Просмотр профилей ───

  Future<void> logTeacherViewed(String teacherId) async {
    await _analytics.logEvent(
      name: 'teacher_viewed',
      parameters: {'teacher_id': teacherId},
    );
  }

  // ─── Поиск ───

  Future<void> logSearch(String query) async {
    await _analytics.logSearch(searchTerm: query);
  }

  // ─── Навигация (экраны) ───

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // ─── Отзывы ───

  Future<void> logReviewCreated({
    required String teacherId,
    required double rating,
  }) async {
    await _analytics.logEvent(
      name: 'review_created',
      parameters: {
        'teacher_id': teacherId,
        'rating': rating,
      },
    );
  }

  // ─── Время намаза ───

  Future<void> logPrayerTimesViewed(String location) async {
    await _analytics.logEvent(
      name: 'prayer_times_viewed',
      parameters: {'location': location},
    );
  }

  // ─── Произвольное событие ───

  Future<void> logCustomEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
