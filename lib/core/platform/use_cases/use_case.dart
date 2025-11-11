import '../../core_exports.dart';

abstract class _BaseUseCase<T, P> {}

abstract class UseCase<T, P> extends _BaseUseCase<T, P> {
  Result<T, Exception> run(P params);
}

abstract class FutureUseCase<T, P> extends _BaseUseCase<T, P> {
  Future<Result<T, Exception>> run(P params);
}

class NoParams {
  const NoParams();
}
