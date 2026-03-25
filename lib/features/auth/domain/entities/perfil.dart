import 'package:equatable/equatable.dart';

/// Perfil entity in domain layer
class Perfil extends Equatable {
  final int id;
  final String perfil;
  final String slug;
  final bool principal;

  const Perfil({
    required this.id,
    required this.perfil,
    required this.slug,
    required this.principal,
  });

  @override
  List<Object?> get props => [
        id,
        perfil,
        slug,
        principal,
      ];
}
