import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Forgot password use case
class ForgotPasswordUseCase {
  final AuthRepository _repository;
  
  ForgotPasswordUseCase({required AuthRepository repository})
      : _repository = repository;
  
  /// Execute forgot password request
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await _repository.forgotPassword(
      email: params.email,
    );
  }
}

/// Parameters for forgot password
class ForgotPasswordParams extends Equatable {
  final String email;
  
  const ForgotPasswordParams({required this.email});
  
  @override
  List<Object> get props => [email];
}