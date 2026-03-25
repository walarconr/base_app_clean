import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/perfil.dart';

part 'perfil_model.freezed.dart';
part 'perfil_model.g.dart';

@freezed
class PerfilModel with _$PerfilModel {
  const PerfilModel._();
  
  const factory PerfilModel({
    required int id,
    @Default('') String perfil,
    @Default('') String slug,
    @Default(false) bool principal,
  }) = _PerfilModel;
  
  factory PerfilModel.fromJson(Map<String, dynamic> json) =>
      _$PerfilModelFromJson(json);
      
  Perfil toEntity() {
    return Perfil(
      id: id,
      perfil: perfil,
      slug: slug,
      principal: principal,
    );
  }
  
  factory PerfilModel.fromEntity(Perfil perfilObj) {
    return PerfilModel(
      id: perfilObj.id,
      perfil: perfilObj.perfil,
      slug: perfilObj.slug,
      principal: perfilObj.principal,
    );
  }
}
