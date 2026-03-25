import 'package:equatable/equatable.dart';
import 'persona.dart';
import 'perfil.dart';

/// User entity in domain layer for Omnicore
class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final bool isVerified;
  final DateTime dateJoined;
  final Persona? persona;
  final List<Perfil> perfiles;
  
  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.isVerified,
    required this.dateJoined,
    this.persona,
    required this.perfiles,
  });
  
  /// Get user initials for avatar placeholder
  String get initials {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    } else if (username.isNotEmpty) {
      return username.substring(0, 2).toUpperCase();
    } else {
      return email.substring(0, 2).toUpperCase();
    }
  }
  
  /// Get display name (name or email)
  String get displayName {
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }
    return username.isNotEmpty ? username : email;
  }
  
  @override
  List<Object?> get props => [
        id,
        email,
        username,
        firstName,
        lastName,
        isVerified,
        dateJoined,
        persona,
        perfiles,
      ];
}