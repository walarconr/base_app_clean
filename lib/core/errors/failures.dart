import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code,
  });
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code,
  });
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred',
    super.code,
  });
}

/// Authentication failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Authentication failed',
    super.code,
  });
}

/// Authorization failure
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    super.message = 'You are not authorized to perform this action',
    super.code,
  });
}

/// Validation failure
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  
  const ValidationFailure({
    super.message = 'Validation failed',
    super.code,
    this.errors,
  });
  
  @override
  List<Object?> get props => [message, code, errors];
}

/// Not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.code,
  });
}

/// Timeout failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timeout',
    super.code,
  });
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unknown error occurred',
    super.code,
  });
}

/// Input failure
class InputFailure extends Failure {
  const InputFailure({
    super.message = 'Invalid input provided',
    super.code,
  });
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission denied',
    super.code,
  });
}

/// Storage failure
class StorageFailure extends Failure {
  const StorageFailure({
    super.message = 'Storage error occurred',
    super.code,
  });
}