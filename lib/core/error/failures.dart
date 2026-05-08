import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache failure'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network failure'});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server failure'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Not found'});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'Unexpected failure'});
}
