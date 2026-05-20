import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'failures.dart';

abstract class BaseUseCase<Type, Params> {
  FutureOr<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class UseCase<BaseBlocState, T> {
  Future<BaseBlocState> call(T params);
}
