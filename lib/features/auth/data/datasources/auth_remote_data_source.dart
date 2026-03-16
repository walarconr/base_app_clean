import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Abstract class for authentication remote data source
abstract class AuthRemoteDataSource {
  /// Login with username and password
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });
  
  /// Register new user
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
  });
  
  /// Logout user
  Future<void> logout();
  
  /// Request password reset
  Future<void> forgotPassword({required String email});
  
  /// Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
  
  /// Get current user profile
  Future<UserModel> getProfile();
  
  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    DateTime? birthDate,
  });
  
  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  /// Verify email with token
  Future<void> verifyEmail({required String token});
  
  /// Resend verification email
  Future<void> resendVerificationEmail();
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  
  AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;
  
  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.login,
      data: {
        'username': username,
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
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      Endpoints.register,
      data: {
        'email': email,
        'password': password,
        'name': name,
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
      await _apiClient.post<void>(Endpoints.logout);
    } finally {
      // Clear tokens regardless of API response
      await _apiClient.clearTokens();
    }
  }
  
  @override
  Future<void> forgotPassword({required String email}) async {
    await _apiClient.post<void>(
      Endpoints.forgotPassword,
      data: {'email': email},
    );
  }
  
  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _apiClient.post<void>(
      Endpoints.resetPassword,
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }
  
  @override
  Future<UserModel> getProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      Endpoints.profile,
    );
    
    return UserModel.fromJson(response);
  }
  
  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    DateTime? birthDate,
  }) async {
    final data = <String, dynamic>{};
    
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (birthDate != null) data['birth_date'] = birthDate.toIso8601String();
    
    final response = await _apiClient.put<Map<String, dynamic>>(
      Endpoints.updateProfile,
      data: data,
    );
    
    return UserModel.fromJson(response);
  }
  
  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.post<void>(
      Endpoints.changePassword,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }
  
  @override
  Future<void> verifyEmail({required String token}) async {
    await _apiClient.post<void>(
      Endpoints.verifyEmail,
      data: {'token': token},
    );
  }
  
  @override
  Future<void> resendVerificationEmail() async {
    await _apiClient.post<void>(
      '${Endpoints.verifyEmail}/resend',
    );
  }
}