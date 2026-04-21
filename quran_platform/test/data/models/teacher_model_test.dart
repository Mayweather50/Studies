import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/data/models/teacher_model.dart';
import 'package:quran_platform/domain/entities/teacher_entity.dart';

void main() {
  group('TeacherModel', () {
    test('fromEntity preserves all fields', () {
      const entity = TeacherEntity(
        id: 't1',
        name: 'Устаз Ибрахим',
        bio: 'Опытный преподаватель',
        experience: '10 лет',
        photoUrl: 'https://example.com/photo.jpg',
        disciplines: ['Таджвид', 'Хифз'],
        ageGroups: ['Молодёжь (18-25)'],
        levels: ['Новичок', 'Базовый'],
        rating: 4.8,
        reviewCount: 25,
        isActive: true,
        schedule: {
          '2024-03-15': ['08:00', '08:45'],
        },
        userId: 'uid_1',
      );

      final model = TeacherModel.fromEntity(entity);

      expect(model.id, 't1');
      expect(model.name, 'Устаз Ибрахим');
      expect(model.bio, 'Опытный преподаватель');
      expect(model.disciplines, ['Таджвид', 'Хифз']);
      expect(model.ageGroups, ['Молодёжь (18-25)']);
      expect(model.levels, ['Новичок', 'Базовый']);
      expect(model.rating, 4.8);
      expect(model.reviewCount, 25);
      expect(model.isActive, isTrue);
      expect(model.schedule['2024-03-15'], ['08:00', '08:45']);
      expect(model.userId, 'uid_1');
    });

    test('toFirestore creates correct map', () {
      const model = TeacherModel(
        id: 't1',
        name: 'Устаз',
        bio: 'Bio',
        experience: '5 лет',
        disciplines: ['Таджвид'],
        ageGroups: ['Дети (6-12)'],
        levels: ['Новичок'],
        rating: 4.5,
        reviewCount: 10,
        isActive: true,
        schedule: {'2024-03-15': ['09:00']},
      );

      final map = model.toFirestore();

      expect(map['name'], 'Устаз');
      expect(map['bio'], 'Bio');
      expect(map['experience'], '5 лет');
      expect(map['disciplines'], ['Таджвид']);
      expect(map['ageGroups'], ['Дети (6-12)']);
      expect(map['levels'], ['Новичок']);
      expect(map['rating'], 4.5);
      expect(map['reviewCount'], 10);
      expect(map['isActive'], isTrue);
      expect(map['schedule'], {'2024-03-15': ['09:00']});
    });

    test('toFirestore omits null photoUrl and userId', () {
      const model = TeacherModel(
        id: 't1', name: 'Test', bio: 'Bio', experience: '1',
      );

      final map = model.toFirestore();
      expect(map.containsKey('photoUrl'), isFalse);
      expect(map.containsKey('userId'), isFalse);
    });

    test('TeacherModel is a TeacherEntity', () {
      const model = TeacherModel(
        id: '1', name: 'Test', bio: 'Bio', experience: '1',
      );
      expect(model, isA<TeacherEntity>());
    });
  });
}
