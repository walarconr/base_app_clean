import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/forgot_password_use_case.dart';

// Data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient: apiClient);
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final apiClient = ref.watch(apiClientProvider);
  
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    secureStorage: secureStorage,
    apiClient: apiClient,
  );
});

// Use cases providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository: repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository: repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository: repository);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repository: repository);
});

// Auth state
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isMockMode;
  
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isMockMode = false,
  });
  
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isMockMode,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isMockMode: isMockMode ?? this.isMockMode,
    );
  }
  
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final AuthRepository _authRepository;
  
  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _authRepository = authRepository,
        super(const AuthState()) {
    _checkAuthStatus();
  }
  
  /// Check initial authentication status
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    
    final isAuthenticated = await _authRepository.isAuthenticated();
    
    if (isAuthenticated) {
      final result = await _authRepository.getCachedUser();
      
      result.fold(
        (failure) {
          state = const AuthState(status: AuthStatus.unauthenticated);
        },
        (user) {
          if (user != null) {
            state = AuthState(
              status: AuthStatus.authenticated,
              user: user,
              isMockMode: _authRepository.isMockMode,
            );
            _refreshProfile();
          } else {
            state = const AuthState(status: AuthStatus.unauthenticated);
          }
        },
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }
  
  /// Refresh user profile in background
  Future<void> _refreshProfile() async {
    final result = await _authRepository.getProfile();
    
    result.fold(
      (failure) {
        // If profile refresh fails, keep cached data
      },
      (user) {
        if (state.isAuthenticated) {
          state = state.copyWith(user: user);
        }
      },
    );
  }
  
  /// Login with username and password
  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    
    final result = await _loginUseCase(
      LoginParams(username: username, password: password),
    );
    
    result.fold(
      (failure) {
        state = AuthState(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
          isMockMode: _authRepository.isMockMode,
        );
      },
    );
  }
  
  /// Register
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    
    final result = await _registerUseCase(
      RegisterParams(email: email, password: password, name: name),
    );
    
    result.fold(
      (failure) {
        state = AuthState(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }
  
  /// Logout
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    
    final result = await _logoutUseCase();
    
    result.fold(
      (failure) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      },
      (_) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      },
    );
  }
  
  /// Forgot password
  Future<bool> forgotPassword({required String email}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    
    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: email),
    );
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return true;
      },
    );
  }
  
  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    DateTime? birthDate,
  }) async {
    if (!state.isAuthenticated) return false;
    
    final result = await _authRepository.updateProfile(
      name: name,
      phone: phone,
      birthDate: birthDate,
    );
    
    return result.fold(
      (failure) => false,
      (user) {
        state = state.copyWith(user: user);
        return true;
      },
    );
  }

  /// Change user password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!state.isAuthenticated) return false;

    final result = await _authRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// Clear error message
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(
        status: state.user != null 
            ? AuthStatus.authenticated 
            : AuthStatus.unauthenticated,
        errorMessage: null,
      );
    }
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final registerUseCase = ref.watch(registerUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  final forgotPasswordUseCase = ref.watch(forgotPasswordUseCaseProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  
  return AuthNotifier(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    logoutUseCase: logoutUseCase,
    forgotPasswordUseCase: forgotPasswordUseCase,
    authRepository: authRepository,
  );
});

// Helper provider to get current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

// Helper provider to check if authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});