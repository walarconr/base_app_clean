import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {
  static ThemeData get theme {
    const primary = Color(0xFF81C784);
    const onPrimary = Color(0xFF003A0D);
    const primaryContainer = Color(0xFF1B5E20);
    const onPrimaryContainer = Color(0xFFB7F0B9);
    const secondary = Color(0xFF90CAF9);
    const onSecondary = Color(0xFF003258);
    const error = Color(0xFFCF6679);
    const onError = Colors.black;
    const surface = Color(0xFF1E1E1E);
    const onSurface = Color(0xFFE0E0E0);
    const background = Color(0xFF121212);

    final text = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        surface: surface,
        onSurface: onSurface,
      ),
      scaffoldBackgroundColor: background,

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withOpacity(0.4),
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(
          color: onSurface,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: onSurface),
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2C2C2C)),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Input ─────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: text.bodyLarge?.copyWith(color: Colors.grey.shade400),
        hintStyle: text.bodyLarge?.copyWith(color: Colors.grey.shade600),
        errorStyle: text.bodySmall?.copyWith(color: error),
      ),

      // ── Filled button ─────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: text.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // ── Elevated button ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: text.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: onPrimary,
          ),
        ),
      ),

      // ── Text button ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // ── Outlined button ───────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // ── Navigation bar (Material 3) ───────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primary.withOpacity(0.16),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: primary, size: 24);
          }
          return IconThemeData(color: Colors.grey.shade500, size: 24);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return text.labelSmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            );
          }
          return text.labelSmall?.copyWith(color: Colors.grey.shade500);
        }),
      ),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ── List tile ─────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: surface,
        selectedTileColor: primary.withOpacity(0.12),
        iconColor: Colors.grey.shade400,
        textColor: onSurface,
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2C2C2C),
        selectedColor: primary.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: text.bodySmall?.copyWith(color: onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),

      // ── Bottom nav (Material 2 legacy) ────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: text.bodySmall,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: text.titleLarge?.copyWith(
          color: onSurface,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: text.bodyMedium?.copyWith(color: onSurface),
      ),

      // ── Snack bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2C2C2C),
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2C2C2C),
        thickness: 1,
        space: 1,
      ),

      // ── Progress indicator ────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: Color(0xFF1B5E20),
        circularTrackColor: Color(0xFF1B5E20),
      ),

      // ── Text ──────────────────────────────────────────────────────────────
      textTheme: text.copyWith(
        displayLarge: text.displayLarge?.copyWith(color: onSurface),
        displayMedium: text.displayMedium?.copyWith(color: onSurface),
        displaySmall: text.displaySmall?.copyWith(color: onSurface),
        headlineLarge: text.headlineLarge?.copyWith(color: onSurface),
        headlineMedium: text.headlineMedium?.copyWith(color: onSurface),
        headlineSmall: text.headlineSmall?.copyWith(color: onSurface),
        titleLarge: text.titleLarge?.copyWith(color: onSurface),
        titleMedium: text.titleMedium?.copyWith(color: onSurface),
        titleSmall: text.titleSmall?.copyWith(color: onSurface),
        bodyLarge: text.bodyLarge?.copyWith(color: onSurface),
        bodyMedium: text.bodyMedium?.copyWith(color: onSurface),
        bodySmall: text.bodySmall?.copyWith(color: Colors.grey.shade400),
        labelLarge: text.labelLarge?.copyWith(color: onSurface),
        labelMedium: text.labelMedium?.copyWith(color: onSurface),
        labelSmall: text.labelSmall?.copyWith(color: Colors.grey.shade400),
      ),
    );
  }
}
