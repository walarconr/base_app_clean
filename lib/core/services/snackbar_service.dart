import 'package:flutter/material.dart';

/// Global snackbar service that works without a [BuildContext].
///
/// ## Setup
/// Pass [scaffoldMessengerKey] to [MaterialApp.scaffoldMessengerKey]:
/// ```dart
/// MaterialApp.router(
///   scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
///   ...
/// )
/// ```
///
/// ## Usage
/// ```dart
/// SnackbarService.showSuccess('Guardado correctamente');
/// SnackbarService.showError('Ocurrió un error');
/// SnackbarService.showWarning('Sesión por expirar');
/// SnackbarService.showInfo('Nueva actualización disponible');
/// ```
class SnackbarService {
  SnackbarService._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static ScaffoldMessengerState? get _messenger =>
      scaffoldMessengerKey.currentState;

  static void showSuccess(String message, {Duration? duration}) {
    _show(
      message: message,
      backgroundColor: const Color(0xFF2E7D32),
      icon: Icons.check_circle_outline_rounded,
      duration: duration,
    );
  }

  static void showError(String message, {Duration? duration}) {
    _show(
      message: message,
      backgroundColor: const Color(0xFFB00020),
      icon: Icons.error_outline_rounded,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  static void showWarning(String message, {Duration? duration}) {
    _show(
      message: message,
      backgroundColor: const Color(0xFFE65100),
      icon: Icons.warning_amber_rounded,
      duration: duration,
    );
  }

  static void showInfo(String message, {Duration? duration}) {
    _show(
      message: message,
      backgroundColor: const Color(0xFF1565C0),
      icon: Icons.info_outline_rounded,
      duration: duration,
    );
  }

  static void _show({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration? duration,
  }) {
    _messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: duration ?? const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
  }
}
