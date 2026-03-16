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
    id: '1',
    email: 'test@test.com',
    name: 'Test User',
    role: UserRole.user,
    isEmailVerified: true,
    isActive: true,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  const tParams = LoginParams(username: 'demo', password: 'demo123');

  group('LoginUseCase', () {
    test('should return User on successful login', () async {
      // arrange
      when(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(tUser));

      // act
      final result = await loginUseCase(tParams);

      // assert
      expect(result, Right(tUser));
      verify(() => mockAuthRepository.login(
            username: 'demo',
            password: 'demo123',
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when login fails', () async {
      // arrange
      const failure = AuthenticationFailure(message: 'Invalid credentials');
      when(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      // act
      final result = await loginUseCase(tParams);

      // assert
      expect(result, const Left(failure));
    });
  });
}
