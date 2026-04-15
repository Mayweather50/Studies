import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    const user = UserEntity(
      id: 'user_1',
      role: 'student',
      name: 'Ахмад',
      email: 'ahmad@test.com',
      phone: '+79991234567',
      avatarUrl: 'https://example.com/avatar.jpg',
      age: 'Молодёжь (18-25)',
      level: 'Новичок',
      favoriteTeachers: ['teacher_1', 'teacher_2'],
    );

    test('creates user with all fields', () {
      expect(user.id, 'user_1');
      expect(user.role, 'student');
      expect(user.name, 'Ахмад');
      expect(user.email, 'ahmad@test.com');
      expect(user.phone, '+79991234567');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.age, 'Молодёжь (18-25)');
      expect(user.level, 'Новичок');
      expect(user.favoriteTeachers, hasLength(2));
    });

    test('isStudent returns true for student role', () {
      expect(user.isStudent, isTrue);
      expect(user.isTeacher, isFalse);
      expect(user.isAdmin, isFalse);
    });

    test('isTeacher returns true for teacher role', () {
      const teacher = UserEntity(id: '1', role: 'teacher', name: 'T');
      expect(teacher.isTeacher, isTrue);
      expect(teacher.isStudent, isFalse);
    });

    test('isAdmin returns true for admin role', () {
      const admin = UserEntity(id: '1', role: 'admin', name: 'A');
      expect(admin.isAdmin, isTrue);
      expect(admin.isStudent, isFalse);
    });

    test('default favoriteTeachers is empty', () {
      const u = UserEntity(id: '1', role: 'student', name: 'Test');
      expect(u.favoriteTeachers, isEmpty);
    });

    test('Equatable comparison works', () {
      const user1 = UserEntity(id: '1', role: 'student', name: 'Test');
      const user2 = UserEntity(id: '1', role: 'student', name: 'Test');
      const user3 = UserEntity(id: '2', role: 'student', name: 'Test');

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });
  });
}
