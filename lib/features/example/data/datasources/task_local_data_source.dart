import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/task.dart';

/// Almacenamiento local de tareas usando SharedPreferences.
///
/// Persiste la lista de tareas como JSON string para funcionar
/// sin conexión al backend.
class TaskLocalDataSource {
  static const String _storageKey = 'local_tasks';

  /// Obtener todas las tareas almacenadas localmente
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    return Task.decodeList(jsonStr);
  }

  /// Guardar una tarea (crear o actualizar)
  Future<List<Task>> saveTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);

    if (index >= 0) {
      // Actualizar existente
      tasks[index] = task.copyWith(
        updatedAt: DateTime.now(),
        syncStatus: SyncStatus.pendingSync,
      );
    } else {
      // Nueva tarea
      tasks.insert(0, task.copyWith(syncStatus: SyncStatus.pendingSync));
    }

    await _persist(tasks);
    return tasks;
  }

  /// Eliminar una tarea por ID
  Future<List<Task>> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await _persist(tasks);
    return tasks;
  }

  /// Guardar toda la lista de tareas (para sync masivo)
  Future<void> saveTasks(List<Task> tasks) async {
    await _persist(tasks);
  }

  /// Marcar tareas como sincronizadas
  Future<List<Task>> markAsSynced(List<String> ids) async {
    final tasks = await getTasks();
    final updated = tasks.map((t) {
      if (ids.contains(t.id)) {
        return t.copyWith(syncStatus: SyncStatus.synced);
      }
      return t;
    }).toList();
    await _persist(updated);
    return updated;
  }

  /// Obtener cantidad de tareas pendientes de sync
  Future<int> getPendingSyncCount() async {
    final tasks = await getTasks();
    return tasks.where((t) => t.syncStatus != SyncStatus.synced).length;
  }

  /// Persistir lista de tareas en SharedPreferences
  Future<void> _persist(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, Task.encodeList(tasks));
  }
}
