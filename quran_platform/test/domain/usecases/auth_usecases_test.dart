import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/core/usecases/usecase.dart';
import 'package:quran_platform/domain/entities/user_entity.dart';
import 'package:quran_platform/domain/repositories/auth_repository.dart';
import 'package:quran_platform/domain/usecases/auth_usecases.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  const testUser = UserEntity(
    id: 'u1', role: 'student', name: 'Ахмад',
  );

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  group('SignInWithGoogle', () {
    test('calls repository.signInWithGoogle', () async {
      when(() => mockRepo.signInWithGoogle())
          .thenAnswer((_) async => testUser);

      final useCase = SignInWithGoogle(mockRepo);
      final result = await useCase(const NoParams());

      expect(result, testUser);
      verify(() => mockRepo.signInWithGoogle()).called(1);
    });
  });

  group('SignInWithPhone', () {
    test('calls repository.signInWithPhone with phone number', () async {
      when(() => mockRepo.signInWithPhone('+79991234567'))
          .thenAnswer((_) async => 'verification_id');

      final useCase = SignInWithPhone(mockRepo);
      final result = await useCase('+79991234567');

      expect(result, 'verification_id');
      verify(() => mockRepo.signInWithPhone('+79991234567')).called(1);
    });
  });

  group('VerifyPhoneCode', () {
    test('calls repository.verifyPhoneCode', () async {
      when(() => mockRepo.verifyPhoneCode('vid', '123456'))
          .thenAnswer((_) async => testUser);

      final useCase = VerifyPhoneCode(mockRepo);
      final result = await useCase(const VerifyPhoneCodeParams(
        verificationId: 'vid', code: '123456',
      ));

      expect(result, testUser);
    });
  });

  group('SignInWithEmail', () {
    test('calls repository.signInWithEmail', () async {
      when(() => mockRepo.signInWithEmail('test@test.com', 'pass'))
          .thenAnswer((_) async => testUser);

      final useCase = SignInWithEmail(mockRepo);
      final result = await useCase(const SignInWithEmailParams(
        email: 'test@test.com', password: 'pass',
      ));

      expect(result, testUser);
    });
  });

  group('SignOut', () {
    test('calls repository.signOut', () async {
      when(() => mockRepo.signOut()).thenAnswer((_) async {});

      final useCase = SignOut(mockRepo);
      await useCase(const NoParams());

      verify(() => mockRepo.signOut()).called(1);
    });
  });

  group('GetCurrentUser', () {
    test('returns user when logged in', () async {
      when(() => mockRepo.getCurrentUser())
          .thenAnswer((_) async => testUser);

      final useCase = GetCurrentUser(mockRepo);
      final result = await useCase(const NoParams());

      expect(result, testUser);
    });

    test('returns null when not logged in', () async {
      when(() => mockRepo.getCurrentUser())
          .thenAnswer((_) async => null);

      final useCase = GetCurrentUser(mockRepo);
      final result = await useCase(const NoParams());

      expect(result, isNull);
    });
  });
}
