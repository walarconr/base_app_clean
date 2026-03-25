import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/presentation/providers/auth_provider.dart';

/// Pantalla de detalle/datos del perfil del usuario
class ProfileDetailScreen extends ConsumerWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Datos del perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ─── Avatar grande ───
            Container(
              width: 100,
              height: 100,
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
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  user?.initials ?? 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ─── Información del usuario ───
            _InfoCard(
              theme: theme,
              children: [
                _InfoRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Nombre completo',
                  value: user?.displayName ?? 'No disponible',
                  theme: theme,
                ),
                _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Correo electrónico',
                  value: user?.email ?? 'No disponible',
                  theme: theme,
                ),
                _InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Rol',
                  value: (user?.perfiles.firstOrNull?.perfil ?? 'user').toUpperCase(),
                  theme: theme,
                  valueColor: const Color(0xFF2E7D32),
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Teléfono',
                  value: (user?.persona?.celular?.isNotEmpty ?? false)
                      ? user!.persona!.celular!
                      : 'No registrado',
                  theme: theme,
                ),
                _InfoRow(
                  icon: Icons.cake_outlined,
                  label: 'Fecha de nacimiento / Ingreso',
                  value: user?.dateJoined != null
                      ? '${user!.dateJoined!.day.toString().padLeft(2, '0')}/${user!.dateJoined!.month.toString().padLeft(2, '0')}/${user!.dateJoined!.year}'
                      : 'No registrada',
                  theme: theme,
                ),
                _InfoRow(
                  icon: Icons.fingerprint_rounded,
                  label: 'ID de usuario',
                  value: user?.id.toString() ?? 'No disponible',
                  theme: theme,
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── Sección de estado de la cuenta ───
            _InfoCard(
              theme: theme,
              children: [
                _InfoRow(
                  icon: Icons.verified_user_outlined,
                  label: 'Estado de la cuenta',
                  value: 'Activa',
                  theme: theme,
                  valueColor: const Color(0xFF4CAF50),
                ),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Miembro desde',
                  value: user?.dateJoined != null
                      ? '${user!.dateJoined!.day}/${user!.dateJoined!.month}/${user!.dateJoined!.year}'
                      : 'No disponible',
                  theme: theme,
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ─── Botón: Editar perfil ───
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push(AppConstants.editProfileRoute),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Editar perfil'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Card contenedor para información
class _InfoCard extends StatelessWidget {
  final ThemeData theme;
  final List<Widget> children;

  const _InfoCard({required this.theme, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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

/// Fila de información del perfil
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final Color? valueColor;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    this.valueColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
