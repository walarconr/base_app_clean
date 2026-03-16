import 'package:equatable/equatable.dart';
import 'dart:convert';

/// Sync status for offline-first pattern
enum SyncStatus {
  synced('synced'),
  pendingSync('pending_sync'),
  pendingDelete('pending_delete');

  final String value;
  const SyncStatus(this.value);

  static SyncStatus fromString(String s) {
    switch (s) {
      case 'synced':
        return SyncStatus.synced;
      case 'pending_delete':
        return SyncStatus.pendingDelete;
      default:
        return SyncStatus.pendingSync;
    }
  }
}

/// Task entity in domain layer
class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final List<String> tags;
  final String? assignedTo;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;
  final SyncStatus syncStatus;
  
  const Task({
    required this.id,
    required this.title,
    this.description,
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.tags = const [],
    this.assignedTo,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
    this.syncStatus = SyncStatus.pendingSync,
  });
  
  /// Create a copy of Task with updated fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    List<String>? tags,
    String? assignedTo,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    SyncStatus? syncStatus,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      tags: tags ?? this.tags,
      assignedTo: assignedTo ?? this.assignedTo,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// Serialize to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.value,
      'priority': priority.value,
      'dueDate': dueDate?.toIso8601String(),
      'tags': tags,
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'syncStatus': syncStatus.value,
    };
  }

  /// Deserialize from JSON map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: TaskStatus.fromString(json['status'] as String? ?? 'pending'),
      priority: TaskPriority.fromString(json['priority'] as String? ?? 'medium'),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assignedTo: json['assignedTo'] as String?,
      createdBy: json['createdBy'] as String? ?? 'local',
      createdAt: DateTime.parse(
          json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
      syncStatus:
          SyncStatus.fromString(json['syncStatus'] as String? ?? 'pending_sync'),
    );
  }

  /// Encode a list of tasks to JSON string
  static String encodeList(List<Task> tasks) {
    return jsonEncode(tasks.map((t) => t.toJson()).toList());
  }

  /// Decode a JSON string to list of tasks
  static List<Task> decodeList(String jsonStr) {
    final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
    return decoded
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  
  /// Check if task is completed
  bool get isCompleted => status == TaskStatus.completed;
  
  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }
  
  /// Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
           dueDate!.month == now.month &&
           dueDate!.day == now.day;
  }
  
  /// Check if needs sync
  bool get needsSync => syncStatus != SyncStatus.synced;
  
  /// Get task progress percentage
  double get progressPercentage {
    switch (status) {
      case TaskStatus.pending:
        return 0.0;
      case TaskStatus.inProgress:
        return 0.5;
      case TaskStatus.review:
        return 0.75;
      case TaskStatus.completed:
        return 1.0;
      case TaskStatus.cancelled:
        return 0.0;
    }
  }
  
  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        priority,
        dueDate,
        tags,
        assignedTo,
        createdBy,
        createdAt,
        updatedAt,
        metadata,
        syncStatus,
      ];
}

/// Task status enumeration
enum TaskStatus {
  pending('pending'),
  inProgress('in_progress'),
  review('review'),
  completed('completed'),
  cancelled('cancelled');
  
  final String value;
  const TaskStatus(this.value);
  
  static TaskStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TaskStatus.pending;
      case 'in_progress':
      case 'inprogress':
        return TaskStatus.inProgress;
      case 'review':
        return TaskStatus.review;
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
      case 'canceled':
        return TaskStatus.cancelled;
      default:
        return TaskStatus.pending;
    }
  }
  
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En progreso';
      case TaskStatus.review:
        return 'Revisión';
      case TaskStatus.completed:
        return 'Completada';
      case TaskStatus.cancelled:
        return 'Cancelada';
    }
  }
  
  int get colorValue {
    switch (this) {
      case TaskStatus.pending:
        return 0xFFFF9800;
      case TaskStatus.inProgress:
        return 0xFF2196F3;
      case TaskStatus.review:
        return 0xFF9C27B0;
      case TaskStatus.completed:
        return 0xFF4CAF50;
      case TaskStatus.cancelled:
        return 0xFF9E9E9E;
    }
  }
}

/// Task priority enumeration
enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high'),
  urgent('urgent');
  
  final String value;
  const TaskPriority(this.value);
  
  static TaskPriority fromString(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      case 'urgent':
        return TaskPriority.urgent;
      default:
        return TaskPriority.medium;
    }
  }
  
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.urgent:
        return 'Urgente';
    }
  }
  
  int get colorValue {
    switch (this) {
      case TaskPriority.low:
        return 0xFF4CAF50;
      case TaskPriority.medium:
        return 0xFF2196F3;
      case TaskPriority.high:
        return 0xFFFF9800;
      case TaskPriority.urgent:
        return 0xFFF44336;
    }
  }
  
  int get sortOrder {
    switch (this) {
      case TaskPriority.low:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.high:
        return 3;
      case TaskPriority.urgent:
        return 4;
    }
  }
}