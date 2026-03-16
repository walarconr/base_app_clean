/// Application constants
class AppConstants {
  // API Configuration (base URL is in EnvConfig)
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // Route Names
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String taskListRoute = '/tasks';
  static const String taskFormRoute = '/task-form';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String notificationsRoute = '/notifications';
  static const String profileDetailRoute = '/profile/details';
  static const String editProfileRoute = '/profile/edit';
  static const String changePasswordRoute = '/profile/change-password';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Server error. Please try again later';
  static const String unauthorizedError = 'Session expired. Please login again';
  static const String validationError = 'Please check your input';
  
  // Success Messages  
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String logoutSuccess = 'Logged out successfully';
  static const String taskCreatedSuccess = 'Task created successfully';
  static const String taskUpdatedSuccess = 'Task updated successfully';
  static const String taskDeletedSuccess = 'Task deleted successfully';
}