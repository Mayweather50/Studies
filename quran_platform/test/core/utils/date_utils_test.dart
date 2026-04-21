import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils.formatDate', () {
    test('formats date correctly', () {
      final date = DateTime(2024, 3, 15);
      expect(AppDateUtils.formatDate(date), '15.03.2024');
    });

    test('pads single digit day and month', () {
      final date = DateTime(2024, 1, 5);
      expect(AppDateUtils.formatDate(date), '05.01.2024');
    });
  });

  group('AppDateUtils.formatTime', () {
    test('formats time correctly', () {
      final date = DateTime(2024, 1, 1, 14, 30);
      expect(AppDateUtils.formatTime(date), '14:30');
    });

    test('pads single digit hours and minutes', () {
      final date = DateTime(2024, 1, 1, 8, 5);
      expect(AppDateUtils.formatTime(date), '08:05');
    });
  });

  group('AppDateUtils.formatDateTime', () {
    test('formats date and time correctly', () {
      final date = DateTime(2024, 3, 15, 14, 30);
      expect(AppDateUtils.formatDateTime(date), '15.03.2024 14:30');
    });
  });

  group('AppDateUtils.isSlotBlocked', () {
    test('returns false for non-Friday', () {
      // Monday
      final monday = DateTime(2024, 3, 18);
      expect(AppDateUtils.isSlotBlocked(monday, 12, 0), isFalse);
      expect(AppDateUtils.isSlotBlocked(monday, 13, 0), isFalse);
    });

    test('returns true for Friday 12:00-14:30', () {
      // Find a Friday
      final friday = DateTime(2024, 3, 15); // March 15, 2024 is Friday
      expect(friday.weekday, DateTime.friday);

      expect(AppDateUtils.isSlotBlocked(friday, 12, 0), isTrue);
      expect(AppDateUtils.isSlotBlocked(friday, 12, 45), isTrue);
      expect(AppDateUtils.isSlotBlocked(friday, 13, 0), isTrue);
      expect(AppDateUtils.isSlotBlocked(friday, 13, 45), isTrue);
      expect(AppDateUtils.isSlotBlocked(friday, 14, 0), isTrue);
    });

    test('returns false for Friday outside blocked range', () {
      final friday = DateTime(2024, 3, 15);
      expect(friday.weekday, DateTime.friday);

      expect(AppDateUtils.isSlotBlocked(friday, 8, 0), isFalse);
      expect(AppDateUtils.isSlotBlocked(friday, 11, 0), isFalse);
      expect(AppDateUtils.isSlotBlocked(friday, 14, 30), isFalse);
      expect(AppDateUtils.isSlotBlocked(friday, 15, 0), isFalse);
      expect(AppDateUtils.isSlotBlocked(friday, 20, 0), isFalse);
    });
  });

  group('AppDateUtils.generateTimeSlots', () {
    test('generates slots from 8:00 to 20:00', () {
      final monday = DateTime(2024, 3, 18);
      final slots = AppDateUtils.generateTimeSlots(monday);

      expect(slots.first, '08:00');
      expect(slots.last, '20:00');
    });

    test('generates 45-minute intervals', () {
      final monday = DateTime(2024, 3, 18);
      final slots = AppDateUtils.generateTimeSlots(monday);

      expect(slots.contains('08:00'), isTrue);
      expect(slots.contains('08:45'), isTrue);
      expect(slots.contains('09:30'), isTrue);
      expect(slots.contains('10:15'), isTrue);
    });

    test('excludes Friday blocked slots', () {
      final friday = DateTime(2024, 3, 15);
      expect(friday.weekday, DateTime.friday);

      final slots = AppDateUtils.generateTimeSlots(friday);

      expect(slots.contains('12:00'), isFalse);
      expect(slots.contains('12:45'), isFalse);
      expect(slots.contains('13:30'), isFalse);
      // 14:30 should NOT be blocked (it's the end boundary)
    });

    test('non-Friday has more slots than Friday', () {
      final friday = DateTime(2024, 3, 15);
      final monday = DateTime(2024, 3, 18);

      final fridaySlots = AppDateUtils.generateTimeSlots(friday);
      final mondaySlots = AppDateUtils.generateTimeSlots(monday);

      expect(mondaySlots.length, greaterThan(fridaySlots.length));
    });
  });

  group('AppDateUtils.getRelativeTime', () {
    test('returns "только что" for recent time', () {
      final now = DateTime.now();
      expect(AppDateUtils.getRelativeTime(now), 'только что');
    });

    test('returns minutes ago', () {
      final time = DateTime.now().subtract(const Duration(minutes: 5));
      expect(AppDateUtils.getRelativeTime(time), '5 мин. назад');
    });

    test('returns hours ago', () {
      final time = DateTime.now().subtract(const Duration(hours: 3));
      expect(AppDateUtils.getRelativeTime(time), '3 ч. назад');
    });

    test('returns days ago', () {
      final time = DateTime.now().subtract(const Duration(days: 2));
      expect(AppDateUtils.getRelativeTime(time), '2 дн. назад');
    });

    test('returns formatted date for 7+ days', () {
      final time = DateTime.now().subtract(const Duration(days: 10));
      final result = AppDateUtils.getRelativeTime(time);
      expect(result, contains('.'));
    });
  });
}
