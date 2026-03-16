import 'package:equatable/equatable.dart';

/// User entity in domain layer
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final DateTime? birthDate;
  final UserRole role;
  final bool isEmailVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    this.birthDate,
    this.role = UserRole.user,
    this.isEmailVerified = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });
  
  /// Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    DateTime? birthDate,
    UserRole? role,
    bool? isEmailVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
  
  /// Get user initials for avatar placeholder
  String get initials {
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty && nameParts.first.isNotEmpty) {
      return nameParts.first.substring(0, 2).toUpperCase();
    } else {
      return email.substring(0, 2).toUpperCase();
    }
  }
  
  /// Get display name (name or email)
  String get displayName => name.isNotEmpty ? name : email;
  
  /// Check if user profile is complete
  bool get isProfileComplete {
    return name.isNotEmpty &&
           phone != null &&
           phone!.isNotEmpty &&
           birthDate != null &&
           isEmailVerified;
  }
  
  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatar,
        phone,
        birthDate,
        role,
        isEmailVerified,
        isActive,
        createdAt,
        updatedAt,
        metadata,
      ];
}

/// User roles enumeration
enum UserRole {
  admin('admin'),
  moderator('moderator'),
  user('user'),
  guest('guest');
  
  final String value;
  const UserRole(this.value);
  
  /// Create UserRole from string
  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'moderator':
        return UserRole.moderator;
      case 'user':
        return UserRole.user;
      case 'guest':
        return UserRole.guest;
      default:
        return UserRole.user;
    }
  }
  
  /// Check if user has admin privileges
  bool get isAdmin => this == UserRole.admin;
  
  /// Check if user has moderator privileges
  bool get isModerator => this == UserRole.admin || this == UserRole.moderator;
  
  /// Check if user is a regular user
  bool get isUser => this == UserRole.user;
  
  /// Check if user is a guest
  bool get isGuest => this == UserRole.guest;
}