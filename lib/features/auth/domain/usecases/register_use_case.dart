import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Register use case
class RegisterUseCase {
  final AuthRepository _repository;
  
  RegisterUseCase({required AuthRepository repository})
      : _repository = repository;
  
  /// Execute registration
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

/// Parameters for registration
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;
  
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });
  
  @override
  List<Object> get props => [email, password, name];
}