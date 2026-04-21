import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/config/env_config.dart';
import 'core/constants/app_constants.dart';
import 'core/widgets/main_shell.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/presentation/forgot_password_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/example/presentation/task_list_screen.dart';
import 'features/example/presentation/task_form_screen.dart';
import 'features/notifications/presentation/notifications_screen.dart';
import 'features/profile/presentation/profile_detail_screen.dart';
import 'features/profile/presentation/edit_profile_screen.dart';
import 'features/profile/presentation/change_password_screen.dart';

/// Router provider.
///
/// The GoRouter is created ONCE and never recreated.
/// [ref.listen] is called directly in the provider body so Riverpod 2 tracks
/// the subscription correctly.  When [authProvider] changes, [_RouterNotifier]
/// fires and GoRouter re-evaluates the [redirect] callback.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier();

  // Keep this ref.listen in the provider body — NOT inside a class constructor. ////
  // This guarantees Riverpod tracks the subscription for the provider's lifetime.**
  ref.listen<AuthState>(authProvider, (_, __) => notifier.notify());

  final router = GoRouter(
    initialLocation: AppConstants.loginRoute,
    debugLogDiagnostics: EnvConfig.instance.isDev,
    refreshListenable: notifier,
    redirect: (context, state) {
      // Always read the current auth state — never capture it at build time.
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isAuthRoute = state.matchedLocation == AppConstants.loginRoute ||
          state.matchedLocation == AppConstants.registerRoute ||
          state.matchedLocation == AppConstants.forgotPasswordRoute;

      if (!isAuthenticated && !isAuthRoute) return AppConstants.loginRoute;
      if (isAuthenticated && isAuthRoute) return AppConstants.homeRoute;
      return null;
    },
    routes: [
      // ── Auth routes (sin Shell) ──
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.forgotPasswordRoute,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ── Rutas protegidas con MainShell (Drawer + BottomNav) ──
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppConstants.homeRoute,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppConstants.taskListRoute,
            name: 'taskList',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TaskListScreen(),
            ),
          ),
          GoRoute(
            path: AppConstants.profileRoute,
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Task form (fuera del shell para navegación de detalle)
      GoRoute(
        path: AppConstants.taskFormRoute,
        name: 'taskForm',
        builder: (context, state) {
          final taskId = state.uri.queryParameters['id'];
          return TaskFormScreen(taskId: taskId);
        },
      ),

      // Notifications
      GoRoute(
        path: AppConstants.notificationsRoute,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Profile detail
      GoRoute(
        path: AppConstants.profileDetailRoute,
        name: 'profileDetail',
        builder: (context, state) => const ProfileDetailScreen(),
      ),

      // Edit profile
      GoRoute(
        path: AppConstants.editProfileRoute,
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),

      // Change password
      GoRoute(
        path: AppConstants.changePasswordRoute,
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );

  // Clean up resources when the provider is disposed.
  ref.onDispose(() {
    notifier.dispose();
    router.dispose();
  });

  return router;
});

/// Minimal ChangeNotifier used only to signal GoRouter to re-evaluate its
/// redirect.  The actual auth logic lives in [routerProvider]'s redirect callback.
class _RouterNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Error page widget
class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Página no encontrada',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'La página que buscas no existe.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              // Only show raw error detail in non-production builds
              if (error != null && !EnvConfig.instance.isProd) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error.toString(),
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go(AppConstants.homeRoute),
                icon: const Icon(Icons.home),
                label: const Text('Ir al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
