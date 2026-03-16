/// Generic state class for any feature.
///
/// Reduces boilerplate — instead of creating a custom state per feature,
/// extend or use `BaseState<T>` directly.
///
/// Example:
/// ```dart
/// final myProvider = StateNotifierProvider<MyNotifier, BaseState<MyData>>(...);
/// ```
enum StateStatus { initial, loading, success, error }

class BaseState<T> {
  final T? data;
  final StateStatus status;
  final String? error;

  const BaseState({
    this.data,
    this.status = StateStatus.initial,
    this.error,
  });

  bool get isInitial => status == StateStatus.initial;
  bool get isLoading => status == StateStatus.loading;
  bool get isSuccess => status == StateStatus.success;
  bool get hasError => status == StateStatus.error;
  bool get hasData => data != null;

  BaseState<T> copyWith({
    T? data,
    StateStatus? status,
    String? error,
  }) {
    return BaseState<T>(
      data: data ?? this.data,
      status: status ?? this.status,
      error: error,
    );
  }

  /// Shortcut: set loading
  BaseState<T> toLoading() => copyWith(status: StateStatus.loading, error: null);

  /// Shortcut: set success with data
  BaseState<T> toSuccess(T data) => BaseState<T>(data: data, status: StateStatus.success);

  /// Shortcut: set error
  BaseState<T> toError(String message) =>
      copyWith(status: StateStatus.error, error: message);
}
