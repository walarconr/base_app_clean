import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../../routes.dart';

/// Drawer lateral de la aplicación
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final theme = Theme.of(context);
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // ─── Header con gradiente ───
          _DrawerHeader(user: user),

          // ─── Items de navegación ───
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerItem(
                  icon: Icons.home_rounded,
                  label: 'Inicio',
                  isSelected: currentRoute == AppConstants.homeRoute,
                  onTap: () => _navigateTo(context, AppConstants.homeRoute),
                ),
                _DrawerItem(
                  icon: Icons.task_alt_rounded,
                  label: 'Tareas',
                  isSelected: currentRoute == AppConstants.taskListRoute,
                  onTap: () => _navigateTo(context, AppConstants.taskListRoute),
                ),
                _DrawerItem(
                  icon: Icons.person_rounded,
                  label: 'Perfil',
                  isSelected: currentRoute == AppConstants.profileRoute,
                  onTap: () => _navigateTo(context, AppConstants.profileRoute),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(),
                ),

                _DrawerItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notificaciones',
                  badge: '3',
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppConstants.notificationsRoute);
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  label: 'Configuración',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to settings
                  },
                ),
                _DrawerItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Ayuda y soporte',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to help
                  },
                ),
              ],
            ),
          ),

          // ─── Footer: Theme toggle + Logout ───
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor.withOpacity(0.3),
                ),
              ),
            ),
            child: Column(
              children: [
                // Toggle de tema
                _DrawerItem(
                  icon: AppTheme.isDarkMode(context)
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  label: AppTheme.isDarkMode(context)
                      ? 'Modo claro'
                      : 'Modo oscuro',
                  onTap: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),
                // Cerrar sesión
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Cerrar sesión',
                  isDestructive: true,
                  onTap: () {
                    // Capture everything from ref BEFORE closing the drawer,
                    // because WidgetRef becomes invalid once the drawer pops.
                    final authNotifier = ref.read(authProvider.notifier);
                    final router = ref.read(routerProvider);
                    final navContext = Navigator.of(context).context;

                    Navigator.pop(context); // close drawer

                    _showLogoutDialog(navContext, authNotifier, router);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer
    context.go(route);
  }

  void _showLogoutDialog(
    BuildContext context,
    AuthNotifier authNotifier,
    GoRouter router,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await authNotifier.logout();
              router.go(AppConstants.loginRoute);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

/// Header del drawer con gradiente y datos del usuario
class _DrawerHeader extends StatelessWidget {
  final User? user;

  const _DrawerHeader({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Center(
              child: false
                  ? ClipOval(
                      child: Image.network(
                        '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildInitials(),
                      ),
                    )
                  : _buildInitials(),
            ),
          ),
          const SizedBox(height: 16),

          // Nombre
          Text(
            user?.displayName ?? 'Usuario',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            user?.email ?? '',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInitials() {
    return Text(
      user?.initials ?? 'U',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Item individual del drawer
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDestructive;
  final String? badge;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.isDestructive = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color itemColor;

    if (isDestructive) {
      itemColor = theme.colorScheme.error;
    } else if (isSelected) {
      itemColor = const Color(0xFF2E7D32);
    } else {
      itemColor = theme.colorScheme.onSurface.withOpacity(0.7);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: isSelected
            ? const Color(0xFF2E7D32).withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: itemColor, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: itemColor,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (isSelected)
                  Container(
                    width: 4,
                    height: 20,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
