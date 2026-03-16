import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base class for all use cases.
///
/// [Type] is the return type on success.
/// [Params] is the input parameters type.
///
/// Example:
/// ```dart
/// class GetProductsUseCase extends UseCase<List<Product>, NoParams> {
///   @override
///   Future<Either<Failure, List<Product>>> call(NoParams params) async {
///     return await repository.getProducts();
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use when the use case doesn't need parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
