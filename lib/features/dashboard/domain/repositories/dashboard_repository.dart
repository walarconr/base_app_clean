import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_data.dart';

/// Abstract repository for dashboard
abstract class DashboardRepository {
  /// Get dashboard data (tries API, falls back to mock)
  Future<Either<Failure, DashboardData>> getDashboard();
}
