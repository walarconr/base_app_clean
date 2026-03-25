import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/persona.dart';

part 'persona_model.freezed.dart';
part 'persona_model.g.dart';

@freezed
class PersonaModel with _$PersonaModel {
  const PersonaModel._();
  
  const factory PersonaModel({
    @Default('') String cedula,
    @Default('') String nombres,
    @Default('') String apellido1,
    @Default('') String apellido2,
    @Default('') String celular,
    @Default('') String telefono,
    @Default('') String email,
  }) = _PersonaModel;
  
  factory PersonaModel.fromJson(Map<String, dynamic> json) =>
      _$PersonaModelFromJson(json);
      
  Persona toEntity() {
    return Persona(
      cedula: cedula,
      nombres: nombres,
      apellido1: apellido1,
      apellido2: apellido2,
      celular: celular,
      telefono: telefono,
      email: email,
    );
  }
  
  factory PersonaModel.fromEntity(Persona persona) {
    return PersonaModel(
      cedula: persona.cedula,
      nombres: persona.nombres,
      apellido1: persona.apellido1,
      apellido2: persona.apellido2,
      celular: persona.celular,
      telefono: persona.telefono,
      email: persona.email,
    );
  }
}
