import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/core/services/crash_service.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class FakeStackTrace extends Fake implements StackTrace {}

void main() {
  late MockFirebaseCrashlytics mockCrashlytics;
  late CrashService crashService;

  setUpAll(() {
    registerFallbackValue(FakeStackTrace());
  });

  setUp(() {
    mockCrashlytics = MockFirebaseCrashlytics();
    crashService = CrashService(mockCrashlytics);
  });

  group('CrashService', () {
    group('init', () {
      test('enables crashlytics collection in release mode', () async {
        when(() => mockCrashlytics.setCrashlyticsCollectionEnabled(any()))
            .thenAnswer((_) async {});

        await crashService.init();

        verify(() => mockCrashlytics.setCrashlyticsCollectionEnabled(any()))
            .called(1);
      });
    });

    group('setUser', () {
      test('sets user identifier', () async {
        when(() => mockCrashlytics.setUserIdentifier(any()))
            .thenAnswer((_) async {});

        await crashService.setUser('user_123');

        verify(() => mockCrashlytics.setUserIdentifier('user_123')).called(1);
      });
    });

    group('clearUser', () {
      test('clears user identifier with empty string', () async {
        when(() => mockCrashlytics.setUserIdentifier(any()))
            .thenAnswer((_) async {});

        await crashService.clearUser();

        verify(() => mockCrashlytics.setUserIdentifier('')).called(1);
      });
    });

    group('recordError', () {
      test('records non-fatal error by default', () async {
        final exception = Exception('test error');
        final stack = StackTrace.current;

        when(() => mockCrashlytics.recordError(
              any<dynamic>(),
              any(),
              reason: any(named: 'reason'),
              fatal: any(named: 'fatal'),
            )).thenAnswer((_) async {});

        await crashService.recordError(exception, stack);

        verify(() => mockCrashlytics.recordError(
              exception,
              stack,
              reason: 'non-fatal error',
              fatal: false,
            )).called(1);
      });

      test('records fatal error when fatal=true', () async {
        final exception = Exception('fatal error');
        final stack = StackTrace.current;

        when(() => mockCrashlytics.recordError(
              any<dynamic>(),
              any(),
              reason: any(named: 'reason'),
              fatal: any(named: 'fatal'),
            )).thenAnswer((_) async {});

        await crashService.recordError(
          exception,
          stack,
          reason: 'custom reason',
          fatal: true,
        );

        verify(() => mockCrashlytics.recordError(
              exception,
              stack,
              reason: 'custom reason',
              fatal: true,
            )).called(1);
      });

      test('uses default reason when not provided', () async {
        when(() => mockCrashlytics.recordError(
              any<dynamic>(),
              any(),
              reason: any(named: 'reason'),
              fatal: any(named: 'fatal'),
            )).thenAnswer((_) async {});

        await crashService.recordError('error', null);

        verify(() => mockCrashlytics.recordError(
              'error',
              null,
              reason: 'non-fatal error',
              fatal: false,
            )).called(1);
      });
    });

    group('log', () {
      test('logs a message to crashlytics', () {
        when(() => mockCrashlytics.log(any())).thenAnswer((_) async {});

        crashService.log('user opened profile');

        verify(() => mockCrashlytics.log('user opened profile')).called(1);
      });
    });

    group('setCustomKey', () {
      test('sets a custom key-value pair', () async {
        when(() => mockCrashlytics.setCustomKey(any(), any<Object>()))
            .thenAnswer((_) async {});

        await crashService.setCustomKey('screen', 'home');

        verify(() => mockCrashlytics.setCustomKey('screen', 'home')).called(1);
      });

      test('supports non-string values', () async {
        when(() => mockCrashlytics.setCustomKey(any(), any<Object>()))
            .thenAnswer((_) async {});

        await crashService.setCustomKey('booking_count', 42);

        verify(() => mockCrashlytics.setCustomKey('booking_count', 42))
            .called(1);
      });
    });
  });
}
