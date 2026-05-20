import 'package:equatable/equatable.dart';

/// Base type for all recoverable failures. Carries a user-facing [message].
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// A remote/server-side error (non-2xx response, parsing error, etc.).
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}

/// No internet connection / connection error.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// A local storage / cache error.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A storage error occurred.']);
}
