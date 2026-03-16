import '../../../../core/network/api_client.dart';
import '../../domain/entities/dashboard_data.dart';

/// Abstract class for dashboard remote data source
abstract class DashboardRemoteDataSource {
  Future<DashboardData> getDashboard();
}

/// Implementation of DashboardRemoteDataSource
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient _apiClient;

  DashboardRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<DashboardData> getDashboard() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/api/dashboard');
    return _parseResponse(response);
  }

  DashboardData _parseResponse(Map<String, dynamic> json) {
    final statsJson = json['userStats'] as Map<String, dynamic>;
    final activitiesJson = json['recentActivities'] as List<dynamic>;
    final notificationsJson = json['notifications'] as List<dynamic>;

    return DashboardData(
      userStats: UserStats(
        totalVisits: statsJson['totalVisits'] as int,
        completedTasks: statsJson['completedTasks'] as int,
        pendingTasks: statsJson['pendingTasks'] as int,
        achievementRate: (statsJson['achievementRate'] as num).toDouble(),
      ),
      recentActivities: activitiesJson
          .map((a) => RecentActivity(
                id: a['id'] as int,
                description: a['description'] as String,
                date: DateTime.parse(a['date'] as String),
                type: a['type'] as String,
              ))
          .toList(),
      notifications: notificationsJson
          .map((n) => AppNotification(
                id: n['id'] as int,
                message: n['message'] as String,
                type: n['type'] as String,
              ))
          .toList(),
    );
  }
}
