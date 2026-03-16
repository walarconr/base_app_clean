import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/task_local_data_source.dart';
import '../../domain/entities/task.dart';

// ─── Data Source Provider ───
final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSource();
});

// ─── State ───
class TaskState {
  final List<Task> tasks;
  final bool isLoading;
  final bool isSyncing;
  final String? error;
  final String? successMessage;

  const TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.isSyncing = false,
    this.error,
    this.successMessage,
  });

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    bool? isSyncing,
    String? error,
    String? successMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      error: error,
      successMessage: successMessage,
    );
  }

  /// Tareas pendientes de sync
  int get pendingSyncCount =>
      tasks.where((t) => t.syncStatus != SyncStatus.synced).length;

  bool get hasPendingSync => pendingSyncCount > 0;
}

// ─── Notifier ───
class TaskNotifier extends StateNotifier<TaskState> {
  final TaskLocalDataSource _dataSource;
  static const _uuid = Uuid();

  TaskNotifier({required TaskLocalDataSource dataSource})
      : _dataSource = dataSource,
        super(const TaskState()) {
    loadTasks();
  }

  /// Cargar tareas desde almacenamiento local
  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final tasks = await _dataSource.getTasks();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar tareas: $e',
      );
    }
  }

  /// Crear nueva tarea
  Future<void> addTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    TaskStatus status = TaskStatus.pending,
    DateTime? dueDate,
  }) async {
    final now = DateTime.now();
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      status: status,
      dueDate: dueDate,
      createdBy: 'local',
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pendingSync,
    );

    try {
      final tasks = await _dataSource.saveTask(task);
      state = state.copyWith(
        tasks: tasks,
        successMessage: 'Tarea creada correctamente',
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al crear tarea: $e');
    }
  }

  /// Actualizar tarea existente
  Future<void> updateTask({
    required String id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
  }) async {
    final existing = state.tasks.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Tarea no encontrada'),
    );

    final updated = existing.copyWith(
      title: title,
      description: description,
      priority: priority,
      status: status,
      dueDate: dueDate,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pendingSync,
    );

    try {
      final tasks = await _dataSource.saveTask(updated);
      state = state.copyWith(
        tasks: tasks,
        successMessage: 'Tarea actualizada',
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al actualizar tarea: $e');
    }
  }

  /// Eliminar tarea
  Future<void> deleteTask(String id) async {
    try {
      final tasks = await _dataSource.deleteTask(id);
      state = state.copyWith(
        tasks: tasks,
        successMessage: 'Tarea eliminada',
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar tarea: $e');
    }
  }

  /// Alternar estado completo/pendiente
  Future<void> toggleTaskStatus(String id) async {
    final task = state.tasks.firstWhere((t) => t.id == id);
    final newStatus = task.isCompleted ? TaskStatus.pending : TaskStatus.completed;
    await updateTask(id: id, status: newStatus);
  }

  /// Sincronizar tareas pendientes con el backend (simulado)
  Future<void> syncTasks() async {
    final pending = state.tasks.where((t) => t.needsSync).toList();
    if (pending.isEmpty) return;

    state = state.copyWith(isSyncing: true, error: null);

    try {
      // ── Simular llamada al backend ──
      // En un proyecto real, aquí enviarías cada tarea al API:
      // for (final task in pending) {
      //   await apiClient.post('/tasks', data: task.toJson());
      // }
      await Future.delayed(const Duration(seconds: 2));

      // Marcar como sincronizadas
      final ids = pending.map((t) => t.id).toList();
      final tasks = await _dataSource.markAsSynced(ids);

      state = state.copyWith(
        tasks: tasks,
        isSyncing: false,
        successMessage: '${pending.length} tarea(s) sincronizada(s)',
      );
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: 'Error al sincronizar: $e',
      );
    }
  }

  /// Limpiar mensajes
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }

  /// Obtener tarea por ID
  Task? getTaskById(String id) {
    try {
      return state.tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}

// ─── Provider ───
final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(
    dataSource: ref.watch(taskLocalDataSourceProvider),
  );
});
