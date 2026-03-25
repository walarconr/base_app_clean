import '../config/env_config.dart';

/// API Endpoints configuration
class Endpoints {
  // Base URL - configured per environment via EnvConfig
  static String get baseUrl => EnvConfig.instance.baseUrl;
  
  // Authentication Endpoints
  static const String login = '/auth/login/';
  static const String logout = '/auth/logout/';
  static const String refreshToken = '/auth/refresh/';
  static const String me = '/auth/me/';
  
  // Dashboard
  static const String dashboard = '/api/dashboard';
  
  // Tasks Endpoints (Example CRUD)
  static const String tasks = '/tasks';
  static String taskById(String id) => '/tasks/$id';
  static const String createTask = '/tasks';
  static String updateTask(String id) => '/tasks/$id';
  static String deleteTask(String id) => '/tasks/$id';
  static String tasksByUser(String userId) => '/users/$userId/tasks';
  static const String taskCategories = '/tasks/categories';
  
  // Users Endpoints
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static const String currentUser = '/users/me';
  
  // File Upload
  static const String upload = '/upload';
  static const String uploadImage = '/upload/image';
  static const String uploadDocument = '/upload/document';
  
  // Notifications
  static const String notifications = '/notifications';
  static String markAsRead(String id) => '/notifications/$id/read';
  static const String markAllAsRead = '/notifications/read-all';
  
  // Search
  static const String search = '/search';
  static const String searchTasks = '/search/tasks';
  static const String searchUsers = '/search/users';
}