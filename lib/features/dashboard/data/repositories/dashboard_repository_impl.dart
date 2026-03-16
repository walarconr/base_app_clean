import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

/// Implementation of DashboardRepository
/// Tries API first, falls back to mock data on any failure
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl({required DashboardRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, DashboardData>> getDashboard() async {
    try {
      final data = await _remoteDataSource.getDashboard();
      return Right(data);
    } catch (e) {
      // API failed — return mock data automatically
      AppLogger.warning('Dashboard API failed: $e. Loading mock data.', tag: 'DASHBOARD');
      return Right(DashboardData.mock());
    }
  }
}
