import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

/// Use case to get dashboard data
class GetDashboardUseCase {
  final DashboardRepository _repository;

  GetDashboardUseCase({required DashboardRepository repository})
      : _repository = repository;

  Future<Either<Failure, DashboardData>> call() async {
    return await _repository.getDashboard();
  }
}
