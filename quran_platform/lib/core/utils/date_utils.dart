import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

class AppDateUtils {
  AppDateUtils._();

  static final DateFormat dateFormat = DateFormat('dd.MM.yyyy');
  static final DateFormat timeFormat = DateFormat('HH:mm');
  static final DateFormat dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat dayMonthFormat = DateFormat('d MMMM', 'ru');
  static final DateFormat weekDayFormat = DateFormat('EEEE', 'ru');

  static String formatDate(DateTime date) => dateFormat.format(date);
  static String formatTime(DateTime date) => timeFormat.format(date);
  static String formatDateTime(DateTime date) => dateTimeFormat.format(date);
  static String formatDayMonth(DateTime date) => dayMonthFormat.format(date);
  static String formatWeekDay(DateTime date) => weekDayFormat.format(date);

  /// Check if a time slot is blocked (Friday 12:00-14:30)
  static bool isSlotBlocked(DateTime date, int hour, int minute) {
    if (date.weekday != DateTime.friday) return false;

    final slotMinutes = hour * 60 + minute;
    final blockStart = AppConstants.fridayBlockedStartHour * 60 +
        AppConstants.fridayBlockedStartMinute;
    final blockEnd = AppConstants.fridayBlockedEndHour * 60 +
        AppConstants.fridayBlockedEndMinute;

    return slotMinutes >= blockStart && slotMinutes < blockEnd;
  }

  /// Generate time slots for a given date
  static List<String> generateTimeSlots(DateTime date) {
    final slots = <String>[];
    for (int hour = 8; hour <= 20; hour++) {
      for (int minute = 0; minute < 60; minute += AppConstants.slotDurationMinutes) {
        if (hour == 20 && minute > 0) break;
        if (!isSlotBlocked(date, hour, minute)) {
          final h = hour.toString().padLeft(2, '0');
          final m = minute.toString().padLeft(2, '0');
          slots.add('$h:$m');
        }
      }
    }
    return slots;
  }

  /// Get relative time string
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин. назад';
    if (diff.inHours < 24) return '${diff.inHours} ч. назад';
    if (diff.inDays < 7) return '${diff.inDays} дн. назад';
    return formatDate(dateTime);
  }
}
