import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/config/env_config.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _secureStorage;
  final ApiClient _apiClient;
  bool _isMockMode = false;
  
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required FlutterSecureStorage secureStorage,
    required ApiClient apiClient,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage,
        _apiClient = apiClient;
  
  @override
  bool get isMockMode => _isMockMode;
  
  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  }) async {
    _isMockMode = false;
    try {
      final authResponse = await _remoteDataSource.login(
        username: username,
        password: password,
      );
      
      // Cache user data
      await _cacheUser(authResponse.user);
      
      return Right(authResponse.user.toEntity());
    } on ApiException catch (e) {
      if (!EnvConfig.instance.isDev) return Left(_mapApiExceptionToFailure(e));
      AppLogger.warning('API login failed: ${e.message}. Trying mock authentication...', tag: 'AUTH');
      return _tryMockLogin(username, password);
    } catch (e) {
      if (!EnvConfig.instance.isDev) return Left(UnknownFailure(message: e.toString()));
      AppLogger.warning('Login error: $e. Trying mock authentication...', tag: 'AUTH');
      return _tryMockLogin(username, password);
    }
  }
  
  /// Try to authenticate with mock credentials
  Future<Either<Failure, User>> _tryMockLogin(String username, String password) async {
    final mockCredentials = {
      'demo': 'demo123',
      'test': 'test123',
      'admin': 'admin123',
    };
    
    if (mockCredentials[username] != password) {
      return const Left(AuthenticationFailure(message: 'Credenciales inválidas'));
    }
    
    final now = DateTime.now();
    final mockUserModel = UserModel(
      id: 'mock-$username',
      email: '$username@demo.local',
      name: username[0].toUpperCase() + username.substring(1),
      role: username == 'admin' ? 'admin' : 'user',
      isEmailVerified: true,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    
    // Store mock token so router guard works
    await _apiClient.updateTokens(token: 'mock-token-$username');
    await _cacheUser(mockUserModel);
    _isMockMode = true;
    
    return Right(mockUserModel.toEntity());
  }
  
  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final authResponse = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      
      await _cacheUser(authResponse.user);
      return Right(authResponse.user.toEntity());
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    // Clear local state FIRST so the app navigates away immediately.
    // The remote call is best-effort (fire-and-forget).
    await _clearCache();
    _isMockMode = false;

    try {
      // Don't await — let it complete in the background.
      // ignore: unawaited_futures
      _remoteDataSource.logout().catchError((_) {});
    } catch (_) {
      // Ignored: local state is already clean.
    }

    return const Right(null);
  }
  
  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final userModel = await _remoteDataSource.getProfile();
      await _cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    DateTime? birthDate,
  }) async {
    try {
      final userModel = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        birthDate: birthDate,
      );
      await _cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    try {
      await _remoteDataSource.verifyEmail(token: token);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> resendVerificationEmail() async {
    try {
      await _remoteDataSource.resendVerificationEmail();
      return const Right(null);
    } on ApiException catch (e) {
      return Left(_mapApiExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    return _apiClient.isAuthenticated;
  }
  
  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    try {
      final userJson = await _secureStorage.read(key: AppConstants.userKey);
      
      if (userJson == null) {
        return const Right(null);
      }
      
      final userData = json.decode(userJson) as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userData);
      
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
  
  /// Cache user data
  Future<void> _cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await _secureStorage.write(
        key: AppConstants.userKey,
        value: userJson,
      );
    } catch (e) {
      // Silently fail caching
    }
  }
  
  /// Clear all cached auth data: user data + JWT tokens.
  Future<void> _clearCache() async {
    try {
      await _secureStorage.delete(key: AppConstants.userKey);
      await _apiClient.clearTokens();
    } catch (e) {
      // Silently fail clearing cache
    }
  }
  
  /// Map API exceptions to failures
  Failure _mapApiExceptionToFailure(ApiException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    } else if (exception is UnauthorizedException) {
      return AuthenticationFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    } else if (exception is ForbiddenException) {
      return AuthorizationFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.statusCode,
        errors: exception.errors,
      );
    } else if (exception is NotFoundException) {
      return NotFoundFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    } else {
      return UnknownFailure(
        message: exception.message,
        code: exception.statusCode,
      );
    }
  }
}