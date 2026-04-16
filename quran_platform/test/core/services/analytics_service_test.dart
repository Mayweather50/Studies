import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/core/services/analytics_service.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late MockFirebaseAnalytics mockAnalytics;
  late AnalyticsService analyticsService;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    analyticsService = AnalyticsService(mockAnalytics);
  });

  group('AnalyticsService', () {
    group('Authentication events', () {
      test('logLogin calls FirebaseAnalytics.logLogin with method', () async {
        when(() => mockAnalytics.logLogin(loginMethod: any(named: 'loginMethod')))
            .thenAnswer((_) async {});

        await analyticsService.logLogin('google');

        verify(() => mockAnalytics.logLogin(loginMethod: 'google')).called(1);
      });

      test('logSignUp calls FirebaseAnalytics.logSignUp with method', () async {
        when(() => mockAnalytics.logSignUp(signUpMethod: any(named: 'signUpMethod')))
            .thenAnswer((_) async {});

        await analyticsService.logSignUp('email');

        verify(() => mockAnalytics.logSignUp(signUpMethod: 'email')).called(1);
      });

      test('logLogout logs a logout event', () async {
        when(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).thenAnswer((_) async {});

        await analyticsService.logLogout();

        verify(() => mockAnalytics.logEvent(name: 'logout')).called(1);
      });

      test('setUser sets ID and role', () async {
        when(() => mockAnalytics.setUserId(id: any(named: 'id')))
            .thenAnswer((_) async {});
        when(() => mockAnalytics.setUserProperty(
              name: any(named: 'name'),
              value: any(named: 'value'),
            )).thenAnswer((_) async {});

        await analyticsService.setUser('user_123', role: 'teacher');

        verify(() => mockAnalytics.setUserId(id: 'user_123')).called(1);
        verify(() => mockAnalytics.setUserProperty(
              name: 'role',
              value: 'teacher',
            )).called(1);
      });

      test('setUser without role does not set property', () async {
        when(() => mockAnalytics.setUserId(id: any(named: 'id')))
            .thenAnswer((_) async {});

        await analyticsService.setUser('user_123');

        verify(() => mockAnalytics.setUserId(id: 'user_123')).called(1);
        verifyNever(() => mockAnalytics.setUserProperty(
              name: any(named: 'name'),
              value: any(named: 'value'),
            ));
      });

      test('clearUser clears user ID', () async {
        when(() => mockAnalytics.setUserId(id: any(named: 'id')))
            .thenAnswer((_) async {});

        await analyticsService.clearUser();

        verify(() => mockAnalytics.setUserId(id: null)).called(1);
      });
    });

    group('Booking events', () {
      test('logBookingCreated logs event with teacher and discipline', () async {
        when(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).thenAnswer((_) async {});

        await analyticsService.logBookingCreated(
          teacherId: 't1',
          discipline: 'Таджвид',
        );

        verify(() => mockAnalytics.logEvent(
              name: 'booking_created',
              parameters: {
                'teacher_id': 't1',
                'discipline': 'Таджвид',
              },
            )).called(1);
      });

      test('logBookingStatusChanged logs booking ID and status', () async {
        when(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).thenAnswer((_) async {});

        await analyticsService.logBookingStatusChanged(
          bookingId: 'b1',
          newStatus: 'confirmed',
        );

        verify(() => mockAnalytics.logEvent(
              name: 'booking_status_changed',
              parameters: {
                'booking_id': 'b1',
                'new_status': 'confirmed',
              },
            )).called(1);
      });
    });

    group('Profile events', () {
      test('logTeacherViewed logs with teacher ID', () async {
        when(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).thenAnswer((_) async {});

        await analyticsService.logTeacherViewed('t_42');

        verify(() => mockAnalytics.logEvent(
              name: 'teacher_viewed',
              parameters: {'teacher_id': 't_42'},
            )).called(1);
      });
    });

    group('Search events', () {
      test('logSearch uses FirebaseAnalytics.logSearch', () async {
        when(() => mockAnalytics.logSearch(searchTerm: any(named: 'searchTerm')))
            .thenAnswer((_) async {});

        await analyticsService.logSearch('Коран');

        verify(() => mockAnalytics.logSearch(searchTerm: 'Коран')).called(1);
      });
    });

    group('Navigation events', () {
      test('logScreenView logs screen name', () async {
        when(() => mockAnalytics.logScreenView(
              screenName: any(named: 'screenName'),
            )).thenAnswer((_) async {});

        await analyticsService.logScreenView('home');

        verify(() => mockAnalytics.logScreenView(screenName: 'home'))
            .called(1);
      });
    });

    group('Review events', () {
      test('logReviewCreated logs teacher ID and rating', () async {
        when(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).thenAnswer((_) async {});

        await analyticsService.logReviewCreated(
          teacherId: 't1',
          rating: 4.5,
        );

        verify(() => mockAnalytics.logEvent(
              name: 'review_created',
              parameters: {
                'teacher_id': 't1',
                'rating': 4.5,
              },
            )).called(1);
      });
    });

    group('Prayer time events', () {
      test('logPrayerTimesViewed logs location', () async {
        when(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).thenAnswer((_) async {});

        await analyticsService.logPrayerTimesViewed('Махачкала');

        verify(() => mockAnalytics.logEvent(
              name: 'prayer_times_viewed',
              parameters: {'location': 'Махачкала'},
            )).called(1);
      });
    });

    group('Custom events', () {
      test('logCustomEvent passes name and parameters', () async {
        when(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).thenAnswer((_) async {});

        await analyticsService.logCustomEvent(
          'lesson_started',
          parameters: {'lesson_id': 'l1'},
        );

        verify(() => mockAnalytics.logEvent(
              name: 'lesson_started',
              parameters: {'lesson_id': 'l1'},
            )).called(1);
      });

      test('logCustomEvent works without parameters', () async {
        when(() => mockAnalytics.logEvent(
              name: any(named: 'name'),
              parameters: any(named: 'parameters'),
            )).thenAnswer((_) async {});

        await analyticsService.logCustomEvent('app_opened');

        verify(() => mockAnalytics.logEvent(
              name: 'app_opened',
              parameters: null,
            )).called(1);
      });
    });

    group('Observer', () {
      test('observer returns a FirebaseAnalyticsObserver instance', () {
        final observer = analyticsService.observer;
        expect(observer, isA<FirebaseAnalyticsObserver>());
      });
    });
  });
}
