import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Abstract class for authentication remote data source
abstract class AuthRemoteDataSource {
  /// Login with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
  
  /// Logout user
  Future<void> logout();
  
  /// Get current user profile
  Future<UserModel> getMe();
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  
  AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;
  
  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    
    final authResponse = AuthResponseModel.fromJson(response);
    
    // Save tokens to ApiClient
    await _apiClient.updateTokens(
      token: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
    );
    
    return authResponse;
  }
  
  @override
  Future<void> logout() async {
    try {
      final rfToken = _apiClient.refreshToken;
      if (rfToken != null && rfToken.isNotEmpty) {
        await _apiClient.post<void>(
          Endpoints.logout,
          data: {'refresh': rfToken},
        );
      }
    } finally {
      // Clear tokens regardless of API response
      await _apiClient.clearTokens();
    }
  }
  
  @override
  Future<UserModel> getMe() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      Endpoints.me,
    );
    
    return UserModel.fromJson(response);
  }
}