import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../services/connectivity_service.dart';
import 'app_drawer.dart';

/// Shell principal que contiene Drawer + BottomNavigationBar
/// Envuelve todas las rutas protegidas de la aplicación.
class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  /// Tabs del BottomNavigationBar
  static const _tabs = [
    _TabConfig(
      route: AppConstants.homeRoute,
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Inicio',
    ),
    _TabConfig(
      route: AppConstants.taskListRoute,
      icon: Icons.task_outlined,
      activeIcon: Icons.task_alt_rounded,
      label: 'Tareas',
    ),
    _TabConfig(
      route: AppConstants.profileRoute,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Perfil',
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _tabs.indexWhere((t) => location.startsWith(t.route));
    return idx >= 0 ? idx : 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIdx = _currentIndex(context);
    final theme = Theme.of(context);
    final isConnected = ref.watch(isConnectedProvider);

    return Scaffold(
      // El drawer vive aquí, a nivel del shell
      drawer: const AppDrawer(),

      // AppBar unificado
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
            tooltip: 'Menú',
          ),
        ),
        title: Text(_tabs[currentIdx].label),
        actions: [
          // Botón de datos de perfil (solo visible en pestaña Perfil)
          if (_tabs[currentIdx].route == AppConstants.profileRoute)
            IconButton(
              icon: const Icon(Icons.badge_outlined),
              onPressed: () =>
                  context.push(AppConstants.profileDetailRoute),
              tooltip: 'Datos del perfil',
            ),
          // Botón de notificaciones (siempre visible)
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () =>
                context.push(AppConstants.notificationsRoute),
            tooltip: 'Notificaciones',
          ),
          const SizedBox(width: 4),
        ],
      ),

      // Body — child del ShellRoute actual
      body: Column(
        children: [
          // Offline banner — shown automatically when connection is lost
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: isConnected
                ? const SizedBox.shrink()
                : Material(
                    color: const Color(0xFFB00020),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sin conexión a internet',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          Expanded(child: child),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIdx,
        onDestinationSelected: (idx) {
          if (idx != currentIdx) {
            context.go(_tabs[idx].route);
          }
        },
        destinations: _tabs.map((tab) {
          return NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.activeIcon),
            label: tab.label,
          );
        }).toList(),
      ),
    );
  }
}

/// Configuración de cada tab
class _TabConfig {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabConfig({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
