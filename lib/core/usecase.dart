import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'failures.dart';

/// A single unit of business logic. Implement this only when a feature's
/// logic is non-trivial or shared — simple features call the repository
/// directly from their Cubit (see docs/ARCHITECTURE.md).
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use as [Params] for use cases that take no arguments.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
