import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository for authentication
abstract class AuthRepository {
  /// Whether the last login was with mock credentials
  bool get isMockMode;
  
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
  
  /// Logout user
  Future<Either<Failure, void>> logout();
  
  /// Get current user profile (Me)
  Future<Either<Failure, User>> getMe();
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Get cached user
  Future<Either<Failure, User?>> getCachedUser();
}