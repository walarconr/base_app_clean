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
      username: params.username,
      password: params.password,
    );
  }
}

/// Parameters for login
class LoginParams extends Equatable {
  final String username;
  final String password;
  
  const LoginParams({
    required this.username,
    required this.password,
  });
  
  @override
  List<Object> get props => [username, password];
}