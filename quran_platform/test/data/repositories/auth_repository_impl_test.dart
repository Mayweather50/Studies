import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/data/datasources/auth_datasource.dart';
import 'package:quran_platform/data/datasources/user_datasource.dart';
import 'package:quran_platform/data/models/user_model.dart';
import 'package:quran_platform/data/repositories/auth_repository_impl.dart';
import 'package:quran_platform/domain/entities/user_entity.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockUserDataSource extends Mock implements UserDataSource {}

class MockFirebaseUser extends Mock implements User {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late MockAuthDataSource mockAuth;
  late MockUserDataSource mockUsers;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockAuth = MockAuthDataSource();
    mockUsers = MockUserDataSource();
    repository = AuthRepositoryImpl(mockAuth, mockUsers);
  });

  group('AuthRepositoryImpl', () {
    final testUser = UserModel(
      id: 'u1',
      role: 'student',
      name: 'Ахмад',
      email: 'a@test.com',
      createdAt: DateTime(2024, 1, 1),
    );

    group('signInWithGoogle', () {
      test('delegates to datasource', () async {
        when(() => mockAuth.signInWithGoogle())
            .thenAnswer((_) async => testUser);

        final result = await repository.signInWithGoogle();

        expect(result, testUser);
        verify(() => mockAuth.signInWithGoogle()).called(1);
      });
    });

    group('signInWithPhone', () {
      test('returns verificationId from datasource', () async {
        when(() => mockAuth.signInWithPhone('+79990000000'))
            .thenAnswer((_) async => 'verif_123');

        final result = await repository.signInWithPhone('+79990000000');

        expect(result, 'verif_123');
        verify(() => mockAuth.signInWithPhone('+79990000000')).called(1);
      });
    });

    group('verifyPhoneCode', () {
      test('delegates to datasource with ID and code', () async {
        when(() => mockAuth.verifyPhoneCode('v1', '123456'))
            .thenAnswer((_) async => testUser);

        final result = await repository.verifyPhoneCode('v1', '123456');

        expect(result, testUser);
        verify(() => mockAuth.verifyPhoneCode('v1', '123456')).called(1);
      });
    });

    group('signInWithEmail', () {
      test('delegates to datasource', () async {
        when(() => mockAuth.signInWithEmail('e@x.com', 'pass'))
            .thenAnswer((_) async => testUser);

        final result = await repository.signInWithEmail('e@x.com', 'pass');

        expect(result, testUser);
      });
    });

    group('signOut', () {
      test('delegates to datasource', () async {
        when(() => mockAuth.signOut()).thenAnswer((_) async {});

        await repository.signOut();

        verify(() => mockAuth.signOut()).called(1);
      });
    });

    group('getCurrentUser', () {
      test('returns user from datasource', () async {
        when(() => mockAuth.getCurrentUser())
            .thenAnswer((_) async => testUser);

        final result = await repository.getCurrentUser();

        expect(result, testUser);
      });

      test('returns null when no user', () async {
        when(() => mockAuth.getCurrentUser()).thenAnswer((_) async => null);

        final result = await repository.getCurrentUser();

        expect(result, isNull);
      });
    });

    group('createUserProfile', () {
      test('converts entity to model and calls datasource', () async {
        const entity = UserEntity(
          id: 'u1',
          role: 'student',
          name: 'Ахмад',
        );

        when(() => mockAuth.createUserProfile(any()))
            .thenAnswer((_) async {});

        await repository.createUserProfile(entity);

        verify(() => mockAuth.createUserProfile(any())).called(1);
      });
    });

    group('authStateChanges (reactive)', () {
      test('emits null when firebase user is null', () async {
        when(() => mockAuth.authStateChanges)
            .thenAnswer((_) => Stream.value(null));

        final emissions = await repository.authStateChanges.take(1).toList();

        expect(emissions, [null]);
        verifyNever(() => mockUsers.watchUser(any()));
      });

      test('uses watchUser stream when firebase user exists', () async {
        final firebaseUser = MockFirebaseUser();
        when(() => firebaseUser.uid).thenReturn('u1');

        when(() => mockAuth.authStateChanges)
            .thenAnswer((_) => Stream.value(firebaseUser));
        when(() => mockUsers.watchUser('u1'))
            .thenAnswer((_) => Stream.value(testUser));

        final result = await repository.authStateChanges.first;

        expect(result, testUser);
        verify(() => mockUsers.watchUser('u1')).called(1);
      });

      test('reactively emits user updates from watchUser (role change)',
          () async {
        final firebaseUser = MockFirebaseUser();
        when(() => firebaseUser.uid).thenReturn('u1');

        final updatedUser = UserModel(
          id: 'u1',
          role: 'teacher', // роль изменилась!
          name: 'Ахмад',
          createdAt: DateTime(2024, 1, 1),
        );

        when(() => mockAuth.authStateChanges)
            .thenAnswer((_) => Stream.value(firebaseUser));
        when(() => mockUsers.watchUser('u1')).thenAnswer(
          (_) => Stream.fromIterable([testUser, updatedUser]),
        );

        final emissions = await repository.authStateChanges.take(2).toList();

        expect(emissions.length, 2);
        expect((emissions[0] as UserModel).role, 'student');
        expect((emissions[1] as UserModel).role, 'teacher');
      });

      test('switches to null when user signs out', () async {
        final firebaseUser = MockFirebaseUser();
        when(() => firebaseUser.uid).thenReturn('u1');

        when(() => mockAuth.authStateChanges).thenAnswer(
          (_) => Stream.fromIterable([firebaseUser, null]),
        );
        when(() => mockUsers.watchUser('u1'))
            .thenAnswer((_) => Stream.value(testUser));

        final emissions = await repository.authStateChanges.take(2).toList();

        expect(emissions[0], testUser);
        expect(emissions[1], isNull);
      });
    });
  });
}
