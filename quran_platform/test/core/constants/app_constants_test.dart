import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    group('App info', () {
      test('appName is correct', () {
        expect(AppConstants.appName, 'Центр заучивания Корана');
      });

      test('appSubtitle is correct', () {
        expect(AppConstants.appSubtitle, 'им. Хасмухаммада Абубакарова');
      });
    });

    group('Disciplines', () {
      test('has 4 disciplines', () {
        expect(AppConstants.disciplines.length, 4);
      });

      test('contains Таджвид', () {
        expect(AppConstants.disciplines, contains('Таджвид'));
      });

      test('contains Хифз', () {
        expect(AppConstants.disciplines, contains('Хифз'));
      });

      test('contains Тафсир', () {
        expect(AppConstants.disciplines, contains('Тафсир'));
      });

      test('contains Коран для детей', () {
        expect(AppConstants.disciplines, contains('Коран для детей'));
      });
    });

    group('Age groups', () {
      test('has 5 age groups', () {
        expect(AppConstants.ageGroups.length, 5);
      });

      test('starts with children group', () {
        expect(AppConstants.ageGroups.first, 'Дети (6-12)');
      });

      test('ends with senior group', () {
        expect(AppConstants.ageGroups.last, 'Старший (45+)');
      });
    });

    group('Levels', () {
      test('has 5 levels', () {
        expect(AppConstants.levels.length, 5);
      });

      test('progression order is correct', () {
        expect(AppConstants.levels, [
          'Новичок',
          'Базовый',
          'Средний',
          'Продвинутый',
          'Хафиз',
        ]);
      });
    });

    group('Booking statuses', () {
      test('statusPending is pending', () {
        expect(AppConstants.statusPending, 'pending');
      });

      test('statusConfirmed is confirmed', () {
        expect(AppConstants.statusConfirmed, 'confirmed');
      });

      test('statusCancelled is cancelled', () {
        expect(AppConstants.statusCancelled, 'cancelled');
      });

      test('statusCompleted is completed', () {
        expect(AppConstants.statusCompleted, 'completed');
      });
    });

    group('Roles', () {
      test('roleStudent is student', () {
        expect(AppConstants.roleStudent, 'student');
      });

      test('roleTeacher is teacher', () {
        expect(AppConstants.roleTeacher, 'teacher');
      });

      test('roleAdmin is admin', () {
        expect(AppConstants.roleAdmin, 'admin');
      });
    });

    group('Friday blocked slots', () {
      test('block starts at 12:00', () {
        expect(AppConstants.fridayBlockedStartHour, 12);
        expect(AppConstants.fridayBlockedStartMinute, 0);
      });

      test('block ends at 14:30', () {
        expect(AppConstants.fridayBlockedEndHour, 14);
        expect(AppConstants.fridayBlockedEndMinute, 30);
      });
    });

    group('Firestore collections', () {
      test('usersCollection is users', () {
        expect(AppConstants.usersCollection, 'users');
      });

      test('teachersCollection is teachers', () {
        expect(AppConstants.teachersCollection, 'teachers');
      });

      test('bookingsCollection is bookings', () {
        expect(AppConstants.bookingsCollection, 'bookings');
      });

      test('reviewsCollection is reviews', () {
        expect(AppConstants.reviewsCollection, 'reviews');
      });
    });

    group('Configuration values', () {
      test('slotDurationMinutes is 45', () {
        expect(AppConstants.slotDurationMinutes, 45);
      });

      test('pageSize is 20', () {
        expect(AppConstants.pageSize, 20);
      });

      test('reminderMinutes has 3 intervals', () {
        expect(AppConstants.reminderMinutes, [60, 30, 15]);
      });

      test('aladhanBaseUrl is correct', () {
        expect(
          AppConstants.aladhanBaseUrl,
          'https://api.aladhan.com/v1',
        );
      });
    });
  });
}
