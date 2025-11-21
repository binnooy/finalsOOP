abstract class Failure {
  final String message;

  Failure({required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required super.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message});
}

class UnknownFailure extends Failure {
  UnknownFailure({required super.message});
}
