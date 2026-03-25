import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';
import 'persona_model.dart';
import 'perfil_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model for data layer with JSON serialization
@freezed
class UserModel with _$UserModel {
  const UserModel._();
  
  const factory UserModel({
    required int id,
    required String email,
    required String username,
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name') @Default('') String lastName,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'date_joined') required DateTime dateJoined,
    PersonaModel? persona,
    @Default([]) List<PerfilModel> perfiles,
  }) = _UserModel;
  
  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  /// Convert UserModel to User entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      isVerified: isVerified,
      dateJoined: dateJoined,
      persona: persona?.toEntity(),
      perfiles: perfiles.map((p) => p.toEntity()).toList(),
    );
  }
  
  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
      isVerified: user.isVerified,
      dateJoined: user.dateJoined,
      persona: user.persona != null ? PersonaModel.fromEntity(user.persona!) : null,
      perfiles: user.perfiles.map((p) => PerfilModel.fromEntity(p)).toList(),
    );
  }
}