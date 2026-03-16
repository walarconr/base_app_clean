import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model for data layer with JSON serialization
@freezed
class UserModel with _$UserModel {
  const UserModel._();
  
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    String? avatar,
    String? phone,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @Default('user') String role,
    @JsonKey(name: 'is_email_verified') @Default(false) bool isEmailVerified,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    Map<String, dynamic>? metadata,
  }) = _UserModel;
  
  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  /// Convert UserModel to User entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      phone: phone,
      birthDate: birthDate,
      role: UserRole.fromString(role),
      isEmailVerified: isEmailVerified,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata,
    );
  }
  
  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      avatar: user.avatar,
      phone: user.phone,
      birthDate: user.birthDate,
      role: user.role.value,
      isEmailVerified: user.isEmailVerified,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      metadata: user.metadata,
    );
  }
}