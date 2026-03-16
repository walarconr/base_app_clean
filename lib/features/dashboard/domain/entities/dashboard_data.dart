import 'package:equatable/equatable.dart';

/// Dashboard data entity
class DashboardData extends Equatable {
  final UserStats userStats;
  final List<RecentActivity> recentActivities;
  final List<AppNotification> notifications;
  final bool isMockData;

  const DashboardData({
    required this.userStats,
    required this.recentActivities,
    required this.notifications,
    this.isMockData = false,
  });

  @override
  List<Object?> get props => [userStats, recentActivities, notifications, isMockData];

  /// Mock data for demo mode
  factory DashboardData.mock() {
    return DashboardData(
      isMockData: true,
      userStats: const UserStats(
        totalVisits: 1543,
        completedTasks: 87,
        pendingTasks: 12,
        achievementRate: 0.78,
      ),
      recentActivities: [
        RecentActivity(id: 1, description: 'Proyecto actualizado', date: DateTime(2026, 2, 12), type: 'update'),
        RecentActivity(id: 2, description: 'Nuevo mensaje de equipo', date: DateTime(2026, 2, 11), type: 'message'),
        RecentActivity(id: 3, description: 'Tarea completada: Revisión', date: DateTime(2026, 2, 10), type: 'task'),
        RecentActivity(id: 4, description: 'Documento compartido', date: DateTime(2026, 2, 9), type: 'share'),
      ],
      notifications: const [
        AppNotification(id: 1, message: '¡Bienvenido de vuelta!', type: 'info'),
        AppNotification(id: 2, message: 'Tienes 3 tareas pendientes', type: 'warning'),
      ],
    );
  }
}

/// User statistics
class UserStats extends Equatable {
  final int totalVisits;
  final int completedTasks;
  final int pendingTasks;
  final double achievementRate;

  const UserStats({
    required this.totalVisits,
    required this.completedTasks,
    required this.pendingTasks,
    required this.achievementRate,
  });

  @override
  List<Object?> get props => [totalVisits, completedTasks, pendingTasks, achievementRate];
}

/// Recent activity entry
class RecentActivity extends Equatable {
  final int id;
  final String description;
  final DateTime date;
  final String type;

  const RecentActivity({
    required this.id,
    required this.description,
    required this.date,
    required this.type,
  });

  @override
  List<Object?> get props => [id, description, date, type];
}

/// App notification
class AppNotification extends Equatable {
  final int id;
  final String message;
  final String type;

  const AppNotification({
    required this.id,
    required this.message,
    required this.type,
  });

  @override
  List<Object?> get props => [id, message, type];
}
