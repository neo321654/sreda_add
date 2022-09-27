import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UnknownException extends Equatable implements Exception {
  final dynamic detail;
  @override
  List get props => [detail];
  const UnknownException(this.detail);
}

Future<Either<Exception, T>> withExceptionHandling<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } catch (e) {
    print("Caught: $e");
    return Left(e is Exception ? e : UnknownException(e));
  }
}
