import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/connectivity_service.dart';
import '../domain/entities/task.dart';
import 'providers/task_provider.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskProvider);
    final isOnline = ref.watch(isConnectedProvider);
    final theme = Theme.of(context);

    // Escuchar mensajes de éxito/error
    ref.listen<TaskState>(taskProvider, (prev, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ));
        ref.read(taskProvider.notifier).clearMessages();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.error!),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ));
        ref.read(taskProvider.notifier).clearMessages();
      }
    });

    return Stack(
      children: [
        Column(
          children: [
            // ─── Banner de conectividad ───
            _ConnectivityBanner(isOnline: isOnline),

            // ─── Barra de sync ───
            if (taskState.hasPendingSync)
              _SyncBar(
                pendingCount: taskState.pendingSyncCount,
                isOnline: isOnline,
                isSyncing: taskState.isSyncing,
                onSync: () => ref.read(taskProvider.notifier).syncTasks(),
              ),

            // ─── Lista o empty state ───
            Expanded(
              child: taskState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : taskState.tasks.isEmpty
                      ? _EmptyState(theme: theme)
                      : RefreshIndicator(
                          onRefresh: () =>
                              ref.read(taskProvider.notifier).loadTasks(),
                          color: const Color(0xFF2E7D32),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                            itemCount: taskState.tasks.length,
                            itemBuilder: (context, index) {
                              final task = taskState.tasks[index];
                              return _TaskTile(
                                task: task,
                                onTap: () =>
                                    context.push('/task-form?id=${task.id}'),
                                onToggle: () => ref
                                    .read(taskProvider.notifier)
                                    .toggleTaskStatus(task.id),
                                onDelete: () => ref
                                    .read(taskProvider.notifier)
                                    .deleteTask(task.id),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),

        // ─── FAB ───
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () => context.push('/task-form'),
            backgroundColor: const Color(0xFF2E7D32),
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────────────────────────

/// Banner de conectividad
class _ConnectivityBanner extends StatelessWidget {
  final bool isOnline;
  const _ConnectivityBanner({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red.shade700,
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Sin conexión a internet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Offline',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Barra de sincronización
class _SyncBar extends StatelessWidget {
  final int pendingCount;
  final bool isOnline;
  final bool isSyncing;
  final VoidCallback onSync;

  const _SyncBar({
    required this.pendingCount,
    required this.isOnline,
    required this.isSyncing,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.orange.shade50,
      child: Row(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            color: Colors.orange.shade700,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$pendingCount tarea(s) pendiente(s) de sincronizar',
              style: TextStyle(
                color: Colors.orange.shade900,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isSyncing)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            TextButton.icon(
              onPressed: isOnline ? onSync : null,
              icon: Icon(
                isOnline ? Icons.sync_rounded : Icons.sync_disabled_rounded,
                size: 18,
              ),
              label: Text(isOnline ? 'Sincronizar' : 'Sin red'),
              style: TextButton.styleFrom(
                foregroundColor:
                    isOnline ? const Color(0xFF2E7D32) : Colors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Empty state
class _EmptyState extends StatelessWidget {
  final ThemeData theme;
  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.task_alt,
              size: 56,
              color: const Color(0xFF2E7D32).withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Sin tareas aún',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Toca el botón + para crear tu primera tarea',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tile de tarea individual
class _TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TaskTile({
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = Color(task.status.colorValue);
    final priorityColor = Color(task.priority.colorValue);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
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
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Checkbox de completado
                GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? const Color(0xFF2E7D32)
                          : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted
                            ? const Color(0xFF2E7D32)
                            : theme.colorScheme.onSurface.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: task.isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? theme.colorScheme.onSurface.withOpacity(0.5)
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.description != null &&
                          task.description!.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          task.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      // Tags: prioridad + estado
                      Row(
                        children: [
                          _MiniChip(
                            label: task.priority.displayName,
                            color: priorityColor,
                          ),
                          const SizedBox(width: 6),
                          _MiniChip(
                            label: task.status.displayName,
                            color: statusColor,
                          ),
                          if (task.isOverdue) ...[
                            const SizedBox(width: 6),
                            _MiniChip(
                              label: 'Vencida',
                              color: Colors.red,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Ícono de sync
                const SizedBox(width: 8),
                _SyncIcon(syncStatus: task.syncStatus),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

/// Ícono de sincronización
class _SyncIcon extends StatelessWidget {
  final SyncStatus syncStatus;
  const _SyncIcon({required this.syncStatus});

  @override
  Widget build(BuildContext context) {
    switch (syncStatus) {
      case SyncStatus.synced:
        return Tooltip(
          message: 'Sincronizada',
          child: Icon(
            Icons.cloud_done_outlined,
            color: const Color(0xFF2E7D32).withOpacity(0.7),
            size: 20,
          ),
        );
      case SyncStatus.pendingSync:
        return Tooltip(
          message: 'Pendiente de sincronizar',
          child: Icon(
            Icons.cloud_upload_outlined,
            color: Colors.orange.shade600,
            size: 20,
          ),
        );
      case SyncStatus.pendingDelete:
        return Tooltip(
          message: 'Pendiente de eliminar en servidor',
          child: Icon(
            Icons.cloud_off_outlined,
            color: Colors.red.shade400,
            size: 20,
          ),
        );
    }
  }
}

/// Chip pequeño para prioridad/estado
class _MiniChip extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}