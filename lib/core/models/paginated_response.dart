/// Generic paginated response wrapper.
///
/// Use with any list API that returns paginated data.
///
/// Example:
/// ```dart
/// PaginatedResponse<Product>.fromJson(
///   json,
///   (item) => ProductModel.fromJson(item).toEntity(),
/// );
/// ```
class PaginatedResponse<T> {
  final List<T> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;

  const PaginatedResponse({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
  });

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
  bool get isEmpty => items.isEmpty;

  /// Parse from a standard API response structure.
  ///
  /// Expects JSON like:
  /// ```json
  /// {
  ///   "data": [...],
  ///   "total": 100,
  ///   "page": 1,
  ///   "totalPages": 5,
  ///   "pageSize": 20
  /// }
  /// ```
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    final items = (json['data'] as List<dynamic>?)
            ?.map((e) => fromJsonItem(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedResponse<T>(
      items: items,
      totalItems: json['total'] as int? ?? items.length,
      currentPage: json['page'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? items.length,
    );
  }
}
