import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// Authentication response model matching Omnicore login response
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    @JsonKey(name: 'access') required String accessToken,
    @JsonKey(name: 'refresh') String? refreshToken,
    required UserModel user,
  }) = _AuthResponseModel;
  
  /// Create AuthResponseModel from JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}