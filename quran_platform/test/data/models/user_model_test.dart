import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/data/models/user_model.dart';
import 'package:quran_platform/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    test('fromEntity creates model from entity', () {
      const entity = UserEntity(
        id: 'u1',
        role: 'student',
        name: 'Ахмад',
        email: 'ahmad@test.com',
        phone: '+79991234567',
        age: 'Молодёжь (18-25)',
        level: 'Новичок',
        favoriteTeachers: ['t1', 't2'],
      );

      final model = UserModel.fromEntity(entity);

      expect(model.id, 'u1');
      expect(model.role, 'student');
      expect(model.name, 'Ахмад');
      expect(model.email, 'ahmad@test.com');
      expect(model.phone, '+79991234567');
      expect(model.age, 'Молодёжь (18-25)');
      expect(model.level, 'Новичок');
      expect(model.favoriteTeachers, ['t1', 't2']);
    });

    test('toFirestore creates correct map', () {
      final model = UserModel(
        id: 'u1',
        role: 'student',
        name: 'Ахмад',
        email: 'ahmad@test.com',
        favoriteTeachers: const ['t1'],
        createdAt: DateTime(2024, 1, 1),
      );

      final map = model.toFirestore();

      expect(map['role'], 'student');
      expect(map['name'], 'Ахмад');
      expect(map['email'], 'ahmad@test.com');
      expect(map['favoriteTeachers'], ['t1']);
      expect(map.containsKey('createdAt'), isTrue);
    });

    test('toFirestore omits null optional fields', () {
      const model = UserModel(
        id: 'u1',
        role: 'student',
        name: 'Test',
      );

      final map = model.toFirestore();

      expect(map.containsKey('email'), isFalse);
      expect(map.containsKey('phone'), isFalse);
      expect(map.containsKey('avatarUrl'), isFalse);
      expect(map.containsKey('age'), isFalse);
      expect(map.containsKey('level'), isFalse);
    });

    test('UserModel is a UserEntity', () {
      const model = UserModel(id: '1', role: 'student', name: 'Test');
      expect(model, isA<UserEntity>());
    });
  });
}
