import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture_app/core/utils/validators.dart';

void main() {
  group('Validators.validateEmail', () {
    test('returns error when email is null', () {
      expect(Validators.validateEmail(null), isNotNull);
    });

    test('returns error when email is empty', () {
      expect(Validators.validateEmail(''), isNotNull);
    });

    test('returns error for invalid email format', () {
      expect(Validators.validateEmail('notanemail'), isNotNull);
      expect(Validators.validateEmail('missing@domain'), isNotNull);
      expect(Validators.validateEmail('@no-local.com'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(Validators.validateEmail('test@example.com'), isNull);
      expect(Validators.validateEmail('user.name@domain.co'), isNull);
    });
  });

  group('Validators.validatePassword', () {
    test('returns error when password is empty', () {
      expect(Validators.validatePassword(''), isNotNull);
    });

    test('returns error when password is too short', () {
      expect(Validators.validatePassword('Ab1!'), isNotNull);
    });

    test('returns error when missing uppercase', () {
      expect(Validators.validatePassword('abcdefg1!'), isNotNull);
    });

    test('returns error when missing lowercase', () {
      expect(Validators.validatePassword('ABCDEFG1!'), isNotNull);
    });

    test('returns error when missing digit', () {
      expect(Validators.validatePassword('Abcdefgh!'), isNotNull);
    });

    test('returns error when missing special character', () {
      expect(Validators.validatePassword('Abcdefg1'), isNotNull);
    });

    test('returns null for valid password', () {
      expect(Validators.validatePassword('Test1234!'), isNull);
    });
  });

  group('Validators.validateRequired', () {
    test('returns error when value is null', () {
      expect(Validators.validateRequired(null), isNotNull);
    });

    test('returns error when value is empty', () {
      expect(Validators.validateRequired(''), isNotNull);
    });

    test('returns error when value is only whitespace', () {
      expect(Validators.validateRequired('   '), isNotNull);
    });

    test('returns null for non-empty value', () {
      expect(Validators.validateRequired('hello'), isNull);
    });
  });

  group('Validators.validateUsername', () {
    test('returns error when username is too short', () {
      expect(Validators.validateUsername('ab'), isNotNull);
    });

    test('returns error for invalid characters', () {
      expect(Validators.validateUsername('user@name'), isNotNull);
      expect(Validators.validateUsername('user name'), isNotNull);
    });

    test('returns null for valid username', () {
      expect(Validators.validateUsername('demo'), isNull);
      expect(Validators.validateUsername('user_123'), isNull);
      expect(Validators.validateUsername('test-user'), isNull);
    });
  });
}
