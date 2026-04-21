class AppConstants {
  AppConstants._();

  // App
  static const String appName = 'Центр заучивания Корана';
  static const String appSubtitle = 'им. Хасмухаммада Абубакарова';

  // Disciplines
  static const List<String> disciplines = [
    'Таджвид',
    'Хифз',
    'Тафсир',
    'Коран для детей',
  ];

  // Age groups
  static const List<String> ageGroups = [
    'Дети (6-12)',
    'Подростки (13-17)',
    'Молодёжь (18-25)',
    'Взрослые (26-45)',
    'Старший (45+)',
  ];

  // Levels
  static const List<String> levels = [
    'Новичок',
    'Базовый',
    'Средний',
    'Продвинутый',
    'Хафиз',
  ];

  // Booking statuses
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusCancelled = 'cancelled';
  static const String statusCompleted = 'completed';

  // Roles
  static const String roleStudent = 'student';
  static const String roleTeacher = 'teacher';
  static const String roleAdmin = 'admin';

  // Friday blocked slots (Juma prayer)
  static const int fridayBlockedStartHour = 12;
  static const int fridayBlockedStartMinute = 0;
  static const int fridayBlockedEndHour = 14;
  static const int fridayBlockedEndMinute = 30;

  // Reminder intervals (in minutes)
  static const List<int> reminderMinutes = [60, 30, 15];

  // Aladhan API
  static const String aladhanBaseUrl = 'https://api.aladhan.com/v1';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String teachersCollection = 'teachers';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';

  // Time slot duration in minutes
  static const int slotDurationMinutes = 45;

  // Pagination
  static const int pageSize = 20;
}
