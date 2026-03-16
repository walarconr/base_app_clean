import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository for authentication
abstract class AuthRepository {
  /// Whether the last login was with mock credentials
  bool get isMockMode;
  
  /// Login with username and password
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });
  
  /// Register new user
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });
  
  /// Logout user
  Future<Either<Failure, void>> logout();
  
  /// Request password reset
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  });
  
  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });
  
  /// Get current user profile
  Future<Either<Failure, User>> getProfile();
  
  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    DateTime? birthDate,
  });
  
  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  /// Verify email with token
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  });
  
  /// Resend verification email
  Future<Either<Failure, void>> resendVerificationEmail();
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Get cached user
  Future<Either<Failure, User?>> getCachedUser();
}