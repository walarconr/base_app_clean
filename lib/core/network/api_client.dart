import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_exceptions.dart';
import 'endpoints.dart';
import '../constants/app_constants.dart';

/// Provider for FlutterSecureStorage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Endpoints.baseUrl,
    connectTimeout: AppConstants.connectionTimeout,
    receiveTimeout: AppConstants.receiveTimeout,
    sendTimeout: AppConstants.connectionTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  return dio;
});

/// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(dio: dio, storage: storage);
});

/// API Client with interceptors and centralized error handling
class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  String? _authToken;
  String? _refreshToken;

  /// Future that completes once tokens are loaded from storage.
  /// Awaited in [_onRequest] so the first request is never sent without a token.
  late final Future<void> _tokenReady;

  /// Lock that prevents concurrent token-refresh calls.
  Completer<void>? _refreshLock;

  ApiClient({
    required Dio dio,
    required FlutterSecureStorage storage,
  })  : _dio = dio,
        _storage = storage {
    _tokenReady = _loadTokens();
    _setupInterceptors();
  }
  
  /// Load tokens from secure storage
  Future<void> _loadTokens() async {
    _authToken = await _storage.read(key: AppConstants.tokenKey);
    _refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
  }
  
  /// Setup Dio interceptors
  void _setupInterceptors() {
    // Remove any existing interceptors
    _dio.interceptors.clear();
    
    // Add logging interceptor (only in debug mode)
    assert(() {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
      return true;
    }());
    
    // Add auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }
  
  /// Request interceptor - Add auth token
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Wait until tokens are loaded from secure storage
    await _tokenReady;

    // Add auth token if available
    if (_authToken != null && _authToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_authToken';
    }

    // Add custom headers
    options.headers['X-Request-ID'] = DateTime.now().millisecondsSinceEpoch.toString();

    handler.next(options);
  }
  
  /// Response interceptor
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }
  
  /// Error interceptor - Handle token refresh and errors
  void _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if error is 401 and we have a refresh token
    if (error.response?.statusCode == 401 && _refreshToken != null) {
      try {
        // Attempt to refresh the token
        await _refreshAccessToken();
        
        // Retry the original request
        final options = error.requestOptions;
        options.headers['Authorization'] = 'Bearer $_authToken';
        
        final response = await _dio.request(
          options.path,
          data: options.data,
          queryParameters: options.queryParameters,
          options: Options(
            method: options.method,
            headers: options.headers,
          ),
        );
        
        handler.resolve(response);
        return;
      } catch (e) {
        // Refresh failed, clear tokens and redirect to login
        await clearTokens();
        handler.reject(error);
        return;
      }
    }
    
    handler.reject(error);
  }
  
  /// Refresh access token.
  ///
  /// Uses a [Completer] lock so concurrent 401 failures only trigger
  /// a single refresh call; all other callers await the same future.
  Future<void> _refreshAccessToken() async {
    // Another refresh is already in progress — wait for it
    if (_refreshLock != null) {
      return _refreshLock!.future;
    }

    _refreshLock = Completer<void>();
    try {
      final response = await _dio.post(
        Endpoints.refreshToken,
        data: {'refresh_token': _refreshToken},
      );

      final newToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await updateTokens(token: newToken, refreshToken: newRefreshToken);
      _refreshLock!.complete();
    } catch (e) {
      _refreshLock!.completeError(e);
      throw UnauthorizedException(message: 'Failed to refresh token');
    } finally {
      _refreshLock = null;
    }
  }
  
  /// Update tokens in storage and memory
  Future<void> updateTokens({
    required String token,
    String? refreshToken,
  }) async {
    _authToken = token;
    await _storage.write(key: AppConstants.tokenKey, value: token);
    
    if (refreshToken != null) {
      _refreshToken = refreshToken;
      await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
    }
  }
  
  /// Clear tokens from storage and memory
  Future<void> clearTokens() async {
    _authToken = null;
    _refreshToken = null;
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }
  
  /// Get current auth token
  String? get authToken => _authToken;
  
  /// Check if user is authenticated
  bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;
  
  // HTTP Methods with error handling
  
  /// GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } catch (e) {
      throw ApiExceptionHandler.handleError(e);
    }
  }
  
  /// POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } catch (e) {
      throw ApiExceptionHandler.handleError(e);
    }
  }
  
  /// PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } catch (e) {
      throw ApiExceptionHandler.handleError(e);
    }
  }
  
  /// PATCH request
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } catch (e) {
      throw ApiExceptionHandler.handleError(e);
    }
  }
  
  /// DELETE request
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data as T;
    } catch (e) {
      throw ApiExceptionHandler.handleError(e);
    }
  }
  
  /// Upload file
  Future<T> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? data,
    Options? options,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        fieldName: await MultipartFile.fromFile(filePath),
      });
      
      final response = await _dio.post<T>(
        path,
        data: formData,
        options: options,
        onSendProgress: onSendProgress,
      );
      
      return response.data as T;
    } catch (e) {
      throw ApiExceptionHandler.handleError(e);
    }
  }
  
  /// Download file
  Future<void> downloadFile(
    String path, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw ApiExceptionHandler.handleError(e);
    }
  }
}