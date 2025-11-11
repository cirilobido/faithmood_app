class CustomError implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  CustomError(this.message, {this.code, this.stackTrace});

  @override
  String toString() => 'CustomError: $message';
}

class NotFoundError extends CustomError {
  NotFoundError(super.message);
}

class TooManyRequestsError extends CustomError {
  TooManyRequestsError(super.message);
}

class InternalServerError extends CustomError {
  InternalServerError(super.message);
}