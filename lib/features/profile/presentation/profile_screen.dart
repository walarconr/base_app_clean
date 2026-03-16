import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes.dart';

/// Pantalla de perfil — ejemplo genérico de pantalla adicional
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ─── Header del perfil ───
          const SizedBox(height: 8),
          _ProfileHeader(
            name: user?.displayName ?? 'Usuario',
            email: user?.email ?? '',
            initials: user?.initials ?? 'U',
            role: user?.role.value ?? 'user',
            avatarUrl: user?.avatar,
          ),
          const SizedBox(height: 28),

          // ─── Sección: Cuenta ───
          _SectionTitle(title: 'Cuenta', theme: theme),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFF2E7D32),
                title: 'Editar perfil',
                subtitle: 'Nombre, teléfono, fecha de nacimiento',
                onTap: () => context.push(AppConstants.editProfileRoute),
              ),
              _SettingsTile(
                icon: Icons.lock_outline_rounded,
                iconColor: Colors.orange,
                title: 'Cambiar contraseña',
                subtitle: 'Actualiza tu contraseña de acceso',
                onTap: () => context.push(AppConstants.changePasswordRoute),
              ),
              _SettingsTile(
                icon: Icons.security_rounded,
                iconColor: Colors.blue,
                title: 'Seguridad',
                subtitle: 'Autenticación de dos factores',
                showDivider: false,
                onTap: () {
                  // TODO: Navigate to security settings
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Sección: Preferencias ───
          _SectionTitle(title: 'Preferencias', theme: theme),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconColor: Colors.purple,
                title: 'Notificaciones',
                subtitle: 'Push, email, SMS',
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
              _SettingsTile(
                icon: Icons.language_rounded,
                iconColor: Colors.teal,
                title: 'Idioma',
                subtitle: 'Español',
                onTap: () {
                  // TODO: Navigate to language settings
                },
              ),
              _SettingsTile(
                icon: AppTheme.isDarkMode(context)
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                iconColor: Colors.amber.shade700,
                title: 'Apariencia',
                subtitle: AppTheme.isDarkMode(context)
                    ? 'Modo oscuro'
                    : 'Modo claro',
                showDivider: false,
                onTap: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Sección: Acerca de ───
          _SectionTitle(title: 'Acerca de', theme: theme),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: Colors.grey,
                title: 'Versión',
                subtitle: '1.0.0',
                showChevron: false,
                showDivider: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ─── Botón de cerrar sesión ───
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final authNotifier = ref.read(authProvider.notifier);
                final router = ref.read(routerProvider);
                showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Cerrar sesión'),
                    content: const Text(
                      '¿Estás seguro de que deseas cerrar sesión?',
                    ),
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
                          backgroundColor: theme.colorScheme.error,
                        ),
                        child: const Text('Cerrar sesión'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
              label: Text(
                'Cerrar sesión',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Header del perfil con avatar, nombre y rol
class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String initials;
  final String role;
  final String? avatarUrl;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.initials,
    required this.role,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Avatar grande
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      avatarUrl!,
                      width: 84,
                      height: 84,
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
          name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),

        // Email
        Text(
          email,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),

        // Badge de rol
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            role.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitials() {
    return Text(
      initials,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Título de sección
class _SectionTitle extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionTitle({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodySmall?.color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Card contenedor para settings
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

/// Tile individual de settings
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool showChevron;
  final bool showDivider;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showChevron = true,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: showDivider
              ? BorderRadius.zero
              : const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (showChevron)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Divider(
              height: 1,
              color: theme.dividerColor.withOpacity(0.3),
            ),
          ),
      ],
    );
  }
}
