import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_architecture_app/core/errors/failures.dart';
import 'package:clean_architecture_app/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_architecture_app/features/auth/domain/usecases/login_use_case.dart';

// Mock
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(repository: mockAuthRepository);
  });

  final tUser = User(
    id: 1,
    username: 'test_demo',
    email: 'test@test.com',
    firstName: 'Test',
    lastName: 'User',
    isVerified: true,
    perfiles: [],
    dateJoined: DateTime(2026, 1, 1),
    persona: null,
  );

  const tParams = LoginParams(email: 'demo', password: 'demo123');

  group('LoginUseCase', () {
    test('should return User on successful login', () async {
      // arrange
      when(() => mockAuthRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(tUser));

      // act
      final result = await loginUseCase(tParams);

      // assert
      expect(result, Right<Failure, User>(tUser));
      verify(() => mockAuthRepository.login(
            email: 'demo',
            password: 'demo123',
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when login fails', () async {
      // arrange
      const failure = AuthenticationFailure(message: 'Invalid credentials');
      when(() => mockAuthRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left<Failure, User>(failure));

      // act
      final result = await loginUseCase(tParams);

      // assert
      expect(result, const Left<Failure, User>(failure));
    });
  });
}
