import 'dart:developer' as developer;
import '../config/env_config.dart';

/// Centralized logger with levels.
///
/// Only logs when `EnvConfig.instance.enableLogging` is true.
/// Usage:
/// ```dart
/// AppLogger.debug('Fetching products...');
/// AppLogger.info('User logged in');
/// AppLogger.warning('Token expires in 5 min');
/// AppLogger.error('API failed', error: e, stackTrace: st);
/// ```
class AppLogger {
  AppLogger._();

  static bool get _enabled {
    try {
      return EnvConfig.instance.enableLogging;
    } catch (_) {
      return true; // if not initialized yet, allow logging
    }
  }

  /// Debug level — verbose development info
  static void debug(String message, {String? tag}) {
    if (!_enabled) return;
    developer.log(
      message,
      name: tag ?? 'DEBUG',
      level: 500,
    );
  }

  /// Info level — important milestones
  static void info(String message, {String? tag}) {
    if (!_enabled) return;
    developer.log(
      message,
      name: tag ?? 'INFO',
      level: 800,
    );
  }

  /// Warning level — something unusual
  static void warning(String message, {String? tag}) {
    if (!_enabled) return;
    developer.log(
      message,
      name: tag ?? 'WARNING',
      level: 900,
    );
  }

  /// Error level — failures and exceptions
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_enabled) return;
    developer.log(
      message,
      name: tag ?? 'ERROR',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
