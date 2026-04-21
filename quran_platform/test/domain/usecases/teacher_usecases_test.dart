import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/domain/entities/teacher_entity.dart';
import 'package:quran_platform/domain/repositories/teacher_repository.dart';
import 'package:quran_platform/domain/usecases/teacher_usecases.dart';

class MockTeacherRepository extends Mock implements TeacherRepository {}

void main() {
  late MockTeacherRepository mockRepo;

  const testTeacher = TeacherEntity(
    id: 't1',
    name: 'Устаз Мухаммад',
    bio: 'Опытный преподаватель',
    experience: '10 лет',
    disciplines: ['Таджвид', 'Хифз'],
    levels: ['Начальный', 'Средний'],
    rating: 4.8,
    reviewCount: 25,
  );

  const testTeacher2 = TeacherEntity(
    id: 't2',
    name: 'Устаз Ахмад',
    bio: 'Преподаватель арабского',
    experience: '5 лет',
    disciplines: ['Арабский язык'],
    levels: ['Начальный'],
    rating: 4.5,
    reviewCount: 12,
  );

  setUp(() {
    mockRepo = MockTeacherRepository();
  });

  setUpAll(() {
    registerFallbackValue(testTeacher);
  });

  group('GetTeachers', () {
    test('calls repository.getTeachers with no filters', () async {
      when(() => mockRepo.getTeachers())
          .thenAnswer((_) async => [testTeacher, testTeacher2]);

      final useCase = GetTeachers(mockRepo);
      final result = await useCase(const GetTeachersParams());

      expect(result, [testTeacher, testTeacher2]);
      expect(result.length, 2);
    });

    test('calls repository.getTeachers with discipline filter', () async {
      when(() => mockRepo.getTeachers(discipline: 'Таджвид'))
          .thenAnswer((_) async => [testTeacher]);

      final useCase = GetTeachers(mockRepo);
      final result = await useCase(
        const GetTeachersParams(discipline: 'Таджвид'),
      );

      expect(result.length, 1);
      expect(result.first.name, 'Устаз Мухаммад');
      verify(() => mockRepo.getTeachers(discipline: 'Таджвид')).called(1);
    });

    test('calls repository.getTeachers with all filters', () async {
      when(() => mockRepo.getTeachers(
            discipline: 'Таджвид',
            ageGroup: 'Взрослые',
            level: 'Начальный',
            searchQuery: 'Мухаммад',
          )).thenAnswer((_) async => [testTeacher]);

      final useCase = GetTeachers(mockRepo);
      final result = await useCase(const GetTeachersParams(
        discipline: 'Таджвид',
        ageGroup: 'Взрослые',
        level: 'Начальный',
        searchQuery: 'Мухаммад',
      ));

      expect(result.length, 1);
    });

    test('returns empty list when no teachers match', () async {
      when(() => mockRepo.getTeachers(discipline: 'Несуществующий'))
          .thenAnswer((_) async => []);

      final useCase = GetTeachers(mockRepo);
      final result = await useCase(
        const GetTeachersParams(discipline: 'Несуществующий'),
      );

      expect(result, isEmpty);
    });
  });

  group('GetTeacherById', () {
    test('returns teacher when found', () async {
      when(() => mockRepo.getTeacherById('t1'))
          .thenAnswer((_) async => testTeacher);

      final useCase = GetTeacherById(mockRepo);
      final result = await useCase('t1');

      expect(result, testTeacher);
      verify(() => mockRepo.getTeacherById('t1')).called(1);
    });

    test('returns null when teacher not found', () async {
      when(() => mockRepo.getTeacherById('nonexistent'))
          .thenAnswer((_) async => null);

      final useCase = GetTeacherById(mockRepo);
      final result = await useCase('nonexistent');

      expect(result, isNull);
    });
  });

  group('CreateTeacher', () {
    test('calls repository.createTeacher', () async {
      when(() => mockRepo.createTeacher(any()))
          .thenAnswer((_) async {});

      final useCase = CreateTeacher(mockRepo);
      await useCase(testTeacher);

      verify(() => mockRepo.createTeacher(testTeacher)).called(1);
    });
  });

  group('UpdateTeacher', () {
    test('calls repository.updateTeacher', () async {
      when(() => mockRepo.updateTeacher(any()))
          .thenAnswer((_) async {});

      final useCase = UpdateTeacher(mockRepo);
      await useCase(testTeacher);

      verify(() => mockRepo.updateTeacher(testTeacher)).called(1);
    });
  });

  group('DeleteTeacher', () {
    test('calls repository.deleteTeacher', () async {
      when(() => mockRepo.deleteTeacher('t1'))
          .thenAnswer((_) async {});

      final useCase = DeleteTeacher(mockRepo);
      await useCase('t1');

      verify(() => mockRepo.deleteTeacher('t1')).called(1);
    });
  });
}
