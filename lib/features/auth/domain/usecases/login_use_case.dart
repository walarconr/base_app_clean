import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Login use case
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase({required AuthRepository repository})
      : _repository = repository;
  
  /// Execute login
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for login
class LoginParams extends Equatable {
  final String email;
  final String password;
  
  const LoginParams({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}