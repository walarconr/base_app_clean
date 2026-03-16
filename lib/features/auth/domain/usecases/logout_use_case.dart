import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Logout use case
class LogoutUseCase {
  final AuthRepository _repository;
  
  LogoutUseCase({required AuthRepository repository})
      : _repository = repository;
  
  /// Execute logout
  Future<Either<Failure, void>> call() async {
    return await _repository.logout();
  }
}