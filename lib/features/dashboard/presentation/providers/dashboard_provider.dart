import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/usecases/get_dashboard_use_case.dart';

// Dependency injection chain
final dashboardDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

final dashboardRepositoryProvider = Provider((ref) {
  return DashboardRepositoryImpl(
    remoteDataSource: ref.watch(dashboardDataSourceProvider),
  );
});

final getDashboardUseCaseProvider = Provider((ref) {
  return GetDashboardUseCase(repository: ref.watch(dashboardRepositoryProvider));
});

// State
class DashboardState {
  final DashboardData? data;
  final bool isLoading;
  final String? error;

  const DashboardState({this.data, this.isLoading = false, this.error});

  DashboardState copyWith({DashboardData? data, bool? isLoading, String? error}) {
    return DashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDashboardUseCase _getDashboardUseCase;

  DashboardNotifier({required GetDashboardUseCase getDashboardUseCase})
      : _getDashboardUseCase = getDashboardUseCase,
        super(const DashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getDashboardUseCase();
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (data) => state = state.copyWith(isLoading: false, data: data),
    );
  }
}

// Provider
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(
    getDashboardUseCase: ref.watch(getDashboardUseCaseProvider),
  );
});
