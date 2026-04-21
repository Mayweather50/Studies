import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error for null', () {
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.email(''), isNotNull);
    });

    test('returns error for invalid email', () {
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
      expect(Validators.email('@domain.com'), isNotNull);
      expect(Validators.email('user@domain'), isNotNull);
      expect(Validators.email('user domain.com'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(Validators.email('user@domain.com'), isNull);
      expect(Validators.email('user.name@domain.co.uk'), isNull);
      expect(Validators.email('user-test@domain.org'), isNull);
      expect(Validators.email('user_name@sub.domain.com'), isNull);
    });
  });

  group('Validators.password', () {
    test('returns error for null', () {
      expect(Validators.password(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.password(''), isNotNull);
    });

    test('returns error for short password', () {
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password('abc'), isNotNull);
    });

    test('returns null for valid password (6+ chars)', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('password'), isNull);
      expect(Validators.password('P@ssw0rd!'), isNull);
    });
  });

  group('Validators.phone', () {
    test('returns error for null', () {
      expect(Validators.phone(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.phone(''), isNotNull);
    });

    test('returns error for invalid phone', () {
      expect(Validators.phone('123'), isNotNull);
      expect(Validators.phone('abcdefghij'), isNotNull);
    });

    test('returns null for valid phone numbers', () {
      expect(Validators.phone('+79991234567'), isNull);
      expect(Validators.phone('89991234567'), isNull);
      expect(Validators.phone('+7 (999) 123-45-67'), isNull);
    });
  });

  group('Validators.name', () {
    test('returns error for null', () {
      expect(Validators.name(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.name(''), isNotNull);
      expect(Validators.name('  '), isNotNull);
    });

    test('returns error for too short name', () {
      expect(Validators.name('A'), isNotNull);
    });

    test('returns null for valid name', () {
      expect(Validators.name('Ахмад'), isNull);
      expect(Validators.name('John Doe'), isNull);
    });
  });

  group('Validators.smsCode', () {
    test('returns error for null', () {
      expect(Validators.smsCode(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.smsCode(''), isNotNull);
    });

    test('returns error for wrong length', () {
      expect(Validators.smsCode('123'), isNotNull);
      expect(Validators.smsCode('1234567'), isNotNull);
    });

    test('returns null for 6-digit code', () {
      expect(Validators.smsCode('123456'), isNull);
      expect(Validators.smsCode('000000'), isNull);
    });
  });

  group('Validators.required', () {
    test('returns error for null', () {
      expect(Validators.required(null), isNotNull);
    });

    test('returns error for empty/whitespace string', () {
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('   '), isNotNull);
    });

    test('returns null for non-empty string', () {
      expect(Validators.required('text'), isNull);
    });

    test('uses custom field name in error', () {
      final result = Validators.required('', 'описание');
      expect(result, contains('описание'));
    });
  });
}
