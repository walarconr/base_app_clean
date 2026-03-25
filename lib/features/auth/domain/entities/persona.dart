import 'package:equatable/equatable.dart';

/// Persona entity in domain layer
class Persona extends Equatable {
  final String cedula;
  final String nombres;
  final String apellido1;
  final String apellido2;
  final String celular;
  final String telefono;
  final String email;

  const Persona({
    required this.cedula,
    required this.nombres,
    required this.apellido1,
    required this.apellido2,
    required this.celular,
    required this.telefono,
    required this.email,
  });

  @override
  List<Object?> get props => [
        cedula,
        nombres,
        apellido1,
        apellido2,
        celular,
        telefono,
        email,
      ];
}
