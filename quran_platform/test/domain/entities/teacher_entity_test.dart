import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/domain/entities/teacher_entity.dart';

void main() {
  group('TeacherEntity', () {
    const teacher = TeacherEntity(
      id: 'teacher_1',
      name: 'Устаз Ибрахим',
      bio: 'Опытный преподаватель Корана',
      experience: '10 лет',
      photoUrl: 'https://example.com/photo.jpg',
      disciplines: ['Таджвид', 'Хифз'],
      ageGroups: ['Молодёжь (18-25)', 'Взрослые (26-45)'],
      levels: ['Новичок', 'Базовый', 'Средний'],
      rating: 4.8,
      reviewCount: 25,
      isActive: true,
      schedule: {
        '2024-03-15': ['08:00', '08:45', '09:30'],
        '2024-03-16': ['10:15', '11:00'],
      },
    );

    test('creates teacher with all fields', () {
      expect(teacher.id, 'teacher_1');
      expect(teacher.name, 'Устаз Ибрахим');
      expect(teacher.bio, 'Опытный преподаватель Корана');
      expect(teacher.experience, '10 лет');
      expect(teacher.photoUrl, isNotNull);
      expect(teacher.disciplines, hasLength(2));
      expect(teacher.ageGroups, hasLength(2));
      expect(teacher.levels, hasLength(3));
      expect(teacher.rating, 4.8);
      expect(teacher.reviewCount, 25);
      expect(teacher.isActive, isTrue);
      expect(teacher.schedule, hasLength(2));
    });

    test('default values are correct', () {
      const t = TeacherEntity(
        id: '1',
        name: 'Test',
        bio: 'Bio',
        experience: '1 год',
      );

      expect(t.disciplines, isEmpty);
      expect(t.ageGroups, isEmpty);
      expect(t.levels, isEmpty);
      expect(t.rating, 0.0);
      expect(t.reviewCount, 0);
      expect(t.isActive, isTrue);
      expect(t.schedule, isEmpty);
      expect(t.photoUrl, isNull);
      expect(t.userId, isNull);
    });

    test('Equatable comparison works', () {
      const t1 = TeacherEntity(
        id: '1', name: 'Test', bio: 'Bio', experience: '1',
      );
      const t2 = TeacherEntity(
        id: '1', name: 'Test', bio: 'Bio', experience: '1',
      );
      const t3 = TeacherEntity(
        id: '2', name: 'Other', bio: 'Bio', experience: '1',
      );

      expect(t1, equals(t2));
      expect(t1, isNot(equals(t3)));
    });
  });
}
