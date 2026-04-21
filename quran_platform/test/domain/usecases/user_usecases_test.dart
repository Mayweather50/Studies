import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/domain/entities/user_entity.dart';
import 'package:quran_platform/domain/repositories/user_repository.dart';
import 'package:quran_platform/domain/usecases/user_usecases.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;

  const testUser = UserEntity(
    id: 'u1',
    role: 'student',
    name: 'Ахмад Абубакаров',
    email: 'ahmad@test.com',
    phone: '+79991234567',
    level: 'Начальный',
    age: '25',
  );

  setUp(() {
    mockRepo = MockUserRepository();
  });

  setUpAll(() {
    registerFallbackValue(testUser);
  });

  group('GetUserProfile', () {
    test('returns user when found', () async {
      when(() => mockRepo.getUserById('u1'))
          .thenAnswer((_) async => testUser);

      final useCase = GetUserProfile(mockRepo);
      final result = await useCase('u1');

      expect(result, testUser);
      expect(result!.name, 'Ахмад Абубакаров');
      expect(result.role, 'student');
      verify(() => mockRepo.getUserById('u1')).called(1);
    });

    test('returns null when user not found', () async {
      when(() => mockRepo.getUserById('nonexistent'))
          .thenAnswer((_) async => null);

      final useCase = GetUserProfile(mockRepo);
      final result = await useCase('nonexistent');

      expect(result, isNull);
    });
  });

  group('UpdateUserProfile', () {
    test('calls repository.updateUser', () async {
      when(() => mockRepo.updateUser(any()))
          .thenAnswer((_) async {});

      final useCase = UpdateUserProfile(mockRepo);
      await useCase(testUser);

      verify(() => mockRepo.updateUser(testUser)).called(1);
    });

    test('updates user with changed fields', () async {
      const updatedUser = UserEntity(
        id: 'u1',
        role: 'student',
        name: 'Ахмад Мухаммадов',
        email: 'ahmad_new@test.com',
        phone: '+79997654321',
        level: 'Средний',
        age: '26',
      );

      when(() => mockRepo.updateUser(any()))
          .thenAnswer((_) async {});

      final useCase = UpdateUserProfile(mockRepo);
      await useCase(updatedUser);

      verify(() => mockRepo.updateUser(updatedUser)).called(1);
    });
  });
}
