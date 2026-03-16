import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ─── String Extensions ───────────────────────────────────────

extension StringExtension on String {
  /// "hello world" → "Hello world"
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// "hello world" → "Hello World"
  String get titleCase =>
      split(' ').map((w) => w.capitalize).join(' ');

  /// Check if string is null-safe empty
  bool get isNullOrEmpty => trim().isEmpty;

  /// Try to parse as DateTime, returns null on failure
  DateTime? toDate([String format = 'yyyy-MM-dd']) {
    try {
      return DateFormat(format).parse(this);
    } catch (_) {
      return DateTime.tryParse(this);
    }
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}

// ─── DateTime Extensions ─────────────────────────────────────

extension DateTimeExtension on DateTime {
  /// "hace 2 horas", "hace 3 días", etc.
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'hace ${diff.inDays}d';
    if (diff.inDays < 30) return 'hace ${diff.inDays ~/ 7} sem';
    if (diff.inDays < 365) return 'hace ${diff.inDays ~/ 30} meses';
    return 'hace ${diff.inDays ~/ 365} años';
  }

  /// "12 Feb 2026"
  String get formatShort => DateFormat('dd MMM yyyy').format(this);

  /// "12/02/2026"
  String get formatSlashed => DateFormat('dd/MM/yyyy').format(this);

  /// "12 Feb 2026, 14:30"
  String get formatFull => DateFormat('dd MMM yyyy, HH:mm').format(this);
}

// ─── BuildContext Extensions ─────────────────────────────────

extension BuildContextExtension on BuildContext {
  /// Quick access to theme
  ThemeData get theme => Theme.of(this);

  /// Quick access to text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Quick access to color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Screen size
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// Show a snackbar
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: colorScheme.error);
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green.shade700);
  }
}
