import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Get current user (Me) use case
class GetMeUseCase {
  final AuthRepository _repository;
  
  GetMeUseCase({required AuthRepository repository})
      : _repository = repository;
  
  /// Execute get user profile
  Future<Either<Failure, User>> call() async {
    return await _repository.getMe();
  }
}
