import 'package:dio/dio.dart';

/// Base class for API exceptions
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  
  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });
  
  @override
  String toString() => message;
}

/// Network connection exception
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
    super.data,
  });
}

/// Server error exception (5xx)
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error occurred',
    super.statusCode = 500,
    super.data,
  });
}

/// Bad request exception (400)
class BadRequestException extends ApiException {
  const BadRequestException({
    super.message = 'Bad request',
    super.statusCode = 400,
    super.data,
  });
}

/// Unauthorized exception (401)
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
    super.data,
  });
}

/// Forbidden exception (403)
class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'Access forbidden',
    super.statusCode = 403,
    super.data,
  });
}

/// Not found exception (404)
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.data,
  });
}

/// Conflict exception (409)
class ConflictException extends ApiException {
  const ConflictException({
    super.message = 'Resource conflict',
    super.statusCode = 409,
    super.data,
  });
}

/// Validation exception (422)
class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;
  
  const ValidationException({
    super.message = 'Validation failed',
    super.statusCode = 422,
    super.data,
    this.errors,
  });
}

/// Timeout exception
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timeout',
    super.statusCode,
    super.data,
  });
}

/// Unknown exception
class UnknownException extends ApiException {
  const UnknownException({
    super.message = 'An unknown error occurred',
    super.statusCode,
    super.data,
  });
}

/// Helper class to handle Dio errors and convert them to custom exceptions
class ApiExceptionHandler {
  static ApiException handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return TimeoutException(
            message: 'Connection timeout',
            data: error.response?.data,
          );
          
        case DioExceptionType.connectionError:
          return NetworkException(
            message: 'No internet connection',
            data: error.response?.data,
          );
          
        case DioExceptionType.badResponse:
          return _handleResponseError(error.response);
          
        case DioExceptionType.cancel:
          return const UnknownException(
            message: 'Request cancelled',
          );
          
        default:
          return UnknownException(
            message: error.message ?? 'Unknown error occurred',
            data: error.response?.data,
          );
      }
    }
    
    return UnknownException(
      message: error.toString(),
    );
  }
  
  static ApiException _handleResponseError(Response? response) {
    if (response == null) {
      return const UnknownException();
    }
    
    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    String message = 'An error occurred';
    
    // Try to extract error message from response
    if (data is Map<String, dynamic>) {
      message = (data['message'] ?? data['error'] ?? data['detail'] ?? message).toString();
    } else if (data is String) {
      message = data;
    }
    
    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 401:
        return UnauthorizedException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 403:
        return ForbiddenException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 404:
        return NotFoundException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 409:
        return ConflictException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 422:
        Map<String, List<String>>? errors;
        if (data is Map<String, dynamic> && data['errors'] != null) {
          errors = Map<String, List<String>>.from(
            (data['errors'] as Map).map(
              (key, value) => MapEntry(
                key,
                value is List ? List<String>.from(value) : [value.toString()],
              ),
            ),
          );
        }
        return ValidationException(
          message: message,
          statusCode: statusCode,
          data: data,
          errors: errors,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      default:
        return UnknownException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
    }
  }
}