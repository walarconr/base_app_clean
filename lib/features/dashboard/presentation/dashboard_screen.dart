import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _balanceVisible = false;

  @override
  Widget build(BuildContext context) {
    final dashState = ref.watch(dashboardProvider);
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final user = authState.user;

    if (dashState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dashState.data == null) {
      return Center(
        child: Text(
          dashState.error ?? 'Sin datos',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    final data = dashState.data!;
    final dateFormat = DateFormat('dd MMM yyyy');
    final now = DateTime.now();
    final greeting = _getGreeting(now);

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardProvider.notifier).loadDashboard(),
      color: const Color(0xFF2E7D32),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // ─── Mock mode banner ───
          if (data.isMockData || authState.isMockMode)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.science_outlined, color: Colors.orange.shade700, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Modo demostración — datos de prueba',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ─── Saludo ───
          Text(
            '$greeting,',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            user?.displayName ?? 'Usuario',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            DateFormat("EEEE dd 'de' MMMM, yyyy", 'es').format(now),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),

          // ─── Card de cuenta / saldo ───
          _AccountCard(
            balanceVisible: _balanceVisible,
            onToggleBalance: () {
              setState(() => _balanceVisible = !_balanceVisible);
            },
          ),
          const SizedBox(height: 24),

          // ─── Acciones rápidas ───
          _SectionHeader(title: 'Acciones rápidas', theme: theme),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickAction(
                icon: Icons.swap_horiz_rounded,
                label: 'Transferir',
                color: const Color(0xFF2E7D32),
                onTap: () {},
              ),
              _QuickAction(
                icon: Icons.receipt_long_rounded,
                label: 'Pagar',
                color: Colors.blue.shade700,
                onTap: () {},
              ),
              _QuickAction(
                icon: Icons.phone_android_rounded,
                label: 'Recargar',
                color: Colors.orange.shade700,
                onTap: () {},
              ),
              _QuickAction(
                icon: Icons.history_rounded,
                label: 'Historial',
                color: Colors.purple.shade600,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ─── Productos para ti ───
          _SectionHeader(title: 'Productos para ti', theme: theme),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: const [
                _ProductCard(
                  icon: Icons.send_rounded,
                  title: 'TransferApp',
                  subtitle: 'Envía dinero al instante desde tu celular',
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                  ),
                ),
                SizedBox(width: 12),
                _ProductCard(
                  icon: Icons.trending_up_rounded,
                  title: 'Inversión Digital',
                  subtitle: 'Haz crecer tu dinero con rendimientos',
                  gradient: LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  ),
                ),
                SizedBox(width: 12),
                _ProductCard(
                  icon: Icons.shield_outlined,
                  title: 'Seguro Digital',
                  subtitle: 'Protege lo que más te importa',
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ─── Estadísticas resumen ───
          _SectionHeader(title: 'Resumen', theme: theme),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: [
              _StatCard(
                icon: Icons.visibility_outlined,
                label: 'Visitas',
                value: '${data.userStats.totalVisits}',
                color: Colors.blue,
                theme: theme,
              ),
              _StatCard(
                icon: Icons.check_circle_outline,
                label: 'Completadas',
                value: '${data.userStats.completedTasks}',
                color: const Color(0xFF2E7D32),
                theme: theme,
              ),
              _StatCard(
                icon: Icons.pending_actions_outlined,
                label: 'Pendientes',
                value: '${data.userStats.pendingTasks}',
                color: Colors.orange,
                theme: theme,
              ),
              _StatCard(
                icon: Icons.trending_up,
                label: 'Logro',
                value: '${(data.userStats.achievementRate * 100).toStringAsFixed(0)}%',
                color: Colors.purple,
                theme: theme,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ─── Actividades recientes ───
          _SectionHeader(title: 'Actividad reciente', theme: theme),
          const SizedBox(height: 12),
          ...data.recentActivities.map((activity) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _activityColor(activity.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _activityIcon(activity.type),
                    color: _activityColor(activity.type),
                    size: 20,
                  ),
                ),
                title: Text(
                  activity.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  dateFormat.format(activity.date),
                  style: theme.textTheme.bodySmall,
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  size: 20,
                ),
              ),
            );
          }),

          // ─── Notificaciones ───
          if (data.notifications.isNotEmpty) ...[
            const SizedBox(height: 20),
            _SectionHeader(title: 'Notificaciones', theme: theme),
            const SizedBox(height: 12),
            ...data.notifications.map((notification) {
              final isWarning = notification.type == 'warning';
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isWarning
                      ? Colors.amber.shade50
                      : const Color(0xFF2E7D32).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isWarning
                        ? Colors.amber.shade200
                        : const Color(0xFF2E7D32).withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.info_outline,
                      color: isWarning
                          ? Colors.amber.shade700
                          : const Color(0xFF2E7D32),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        notification.message,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  String _getGreeting(DateTime now) {
    final hour = now.hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'update':
        return Icons.update;
      case 'message':
        return Icons.message_outlined;
      case 'task':
        return Icons.task_alt;
      case 'share':
        return Icons.share_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _activityColor(String type) {
    switch (type) {
      case 'update':
        return Colors.blue;
      case 'message':
        return Colors.teal;
      case 'task':
        return const Color(0xFF2E7D32);
      case 'share':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────────────────────────

/// Header de sección
class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Card de cuenta con saldo
class _AccountCard extends StatelessWidget {
  final bool balanceVisible;
  final VoidCallback onToggleBalance;

  const _AccountCard({
    required this.balanceVisible,
    required this.onToggleBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cuenta Principal',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Ahorros',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Saldo
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                balanceVisible ? '\$4,532.80' : '\$••••••',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onToggleBalance,
                child: Icon(
                  balanceVisible
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: Colors.white.withOpacity(0.7),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Disponible',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Acción rápida circular
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de producto horizontal
class _ProductCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;

  const _ProductCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
