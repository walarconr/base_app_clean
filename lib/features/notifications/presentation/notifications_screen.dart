import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Modelo de datos para una notificación local de ejemplo
class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final DateTime timestamp;
  final bool isRead;

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.timestamp,
    this.isRead = false,
  });
}

/// Pantalla de notificaciones con lista de ejemplo
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Datos mock de notificaciones
  late final List<_NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _notifications = [
      _NotificationItem(
        id: '1',
        title: 'Tarea completada',
        message: 'La tarea "Diseño de UI" ha sido marcada como completada.',
        icon: Icons.task_alt_rounded,
        iconColor: const Color(0xFF4CAF50),
        timestamp: now.subtract(const Duration(minutes: 5)),
      ),
      _NotificationItem(
        id: '2',
        title: 'Nuevo comentario',
        message: 'Juan Pérez comentó en tu tarea "Revisión de código".',
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: const Color(0xFF2196F3),
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
      _NotificationItem(
        id: '3',
        title: 'Recordatorio',
        message: 'Tu tarea "Entrega del reporte" vence mañana.',
        icon: Icons.alarm_rounded,
        iconColor: const Color(0xFFFF9800),
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      _NotificationItem(
        id: '4',
        title: 'Asignación nueva',
        message: 'Se te ha asignado la tarea "Implementar notificaciones".',
        icon: Icons.assignment_ind_rounded,
        iconColor: const Color(0xFF9C27B0),
        timestamp: now.subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      _NotificationItem(
        id: '5',
        title: 'Actualización del sistema',
        message: 'La aplicación se ha actualizado a la versión 1.1.0.',
        icon: Icons.system_update_rounded,
        iconColor: const Color(0xFF607D8B),
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount =
        _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notificaciones'),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  for (var i = 0; i < _notifications.length; i++) {
                    _notifications[i] = _NotificationItem(
                      id: _notifications[i].id,
                      title: _notifications[i].title,
                      message: _notifications[i].message,
                      icon: _notifications[i].icon,
                      iconColor: _notifications[i].iconColor,
                      timestamp: _notifications[i].timestamp,
                      isRead: true,
                    );
                  }
                });
              },
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Leer todo'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(theme)
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(left: 72),
                child: Divider(
                  height: 1,
                  color: theme.dividerColor.withOpacity(0.3),
                ),
              ),
              itemBuilder: (context, index) {
                return _NotificationTile(
                  notification: _notifications[index],
                  onTap: () {
                    setState(() {
                      final n = _notifications[index];
                      if (!n.isRead) {
                        _notifications[index] = _NotificationItem(
                          id: n.id,
                          title: n.title,
                          message: n.message,
                          icon: n.icon,
                          iconColor: n.iconColor,
                          timestamp: n.timestamp,
                          isRead: true,
                        );
                      }
                    });
                  },
                  onDismissed: () {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notificación eliminada'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 40,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin notificaciones',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No tienes notificaciones por el momento.\nTe avisaremos cuando haya algo nuevo.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tile de cada notificación
class _NotificationTile extends StatelessWidget {
  final _NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: notification.isRead
              ? Colors.transparent
              : theme.colorScheme.primary.withOpacity(0.04),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícono
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: notification.iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(notification.isRead ? 0.6 : 0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
