import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/paginated_response.dart';

/// State for paginated data.
class PaginatedState<T> {
  final List<T> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const PaginatedState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 0,
    this.hasMore = true,
  });

  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Base notifier for paginated lists.
///
/// Subclass and implement [fetchPage] to get paginated data:
/// ```dart
/// class ProductListNotifier extends PaginatedNotifier<Product> {
///   @override
///   Future<PaginatedResponse<Product>> fetchPage(int page) {
///     return productRepository.getProducts(page: page);
///   }
/// }
/// ```
abstract class PaginatedNotifier<T>
    extends StateNotifier<PaginatedState<T>> {
  PaginatedNotifier() : super(const PaginatedState()) {
    loadFirstPage();
  }

  /// Override: fetch a single page of data.
  Future<PaginatedResponse<T>> fetchPage(int page);

  /// Load (or reload) the first page.
  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await fetchPage(1);
      state = PaginatedState<T>(
        items: response.items,
        currentPage: 1,
        hasMore: response.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load the next page (append to existing items).
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final response = await fetchPage(nextPage);
      state = state.copyWith(
        items: [...state.items, ...response.items],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: response.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// Refresh: clear and reload from page 1.
  Future<void> refresh() => loadFirstPage();
}
