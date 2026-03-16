import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/env_config.dart';
import 'core/services/snackbar_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Global Flutter error handler ──────────────────────────────────────────
  // Catches errors thrown inside the Flutter framework (widget build, layout…)
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(
      'Flutter framework error',
      tag: 'FlutterError',
      error: details.exception,
      stackTrace: details.stack,
    );
    // In production, forward to the platform error handler
    // so crash-reporting services (e.g. Firebase Crashlytics) receive it.
    if (!kDebugMode) {
      PlatformDispatcher.instance.onError?.call(
        details.exception,
        details.stack ?? StackTrace.empty,
      );
    }
  };

  // ── Global platform/isolate error handler ─────────────────────────────────
  // Catches errors that escape the framework (async gaps, isolates…)
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error(
      'Uncaught platform error',
      tag: 'PlatformDispatcher',
      error: error,
      stackTrace: stack,
    );
    // Return true to prevent the default error-reporting behaviour.
    // Replace with false (or add crash reporting here) if needed.
    return true;
  };

  // Initialize locale data for date formatting (Spanish)
  await initializeDateFormatting('es');

  // Configure environment (change this per build flavor)
  EnvConfig.initialize(Environment.dev);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// Main application widget.
///
/// Uses [ConsumerStatefulWidget] to support [WidgetsBindingObserver]
/// for app-lifecycle events.
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called whenever the app's lifecycle state changes.
  /// Override here to react to foreground/background transitions.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        AppLogger.info('App resumed', tag: 'Lifecycle');
      case AppLifecycleState.paused:
        AppLogger.info('App paused', tag: 'Lifecycle');
      case AppLifecycleState.detached:
        AppLogger.info('App detached', tag: 'Lifecycle');
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,

          // Global scaffold messenger key — enables SnackbarService
          scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,

          // App information
          title: EnvConfig.instance.appName,
          debugShowCheckedModeBanner: false,

          // Theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,

          builder: (context, child) {
            // Prevent text scaling beyond certain limits
            Widget result = MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context).textScaler.clamp(
                      minScaleFactor: 0.8,
                      maxScaleFactor: 1.2,
                    ),
              ),
              child: child ?? const SizedBox.shrink(),
            );

            // DEV environment banner
            if (EnvConfig.instance.isDev) {
              result = Banner(
                message: 'DEV',
                location: BannerLocation.topEnd,
                color: const Color(0xFFFF6D00),
                child: result,
              );
            }

            return result;
          },
        );
      },
    );
  }
}
