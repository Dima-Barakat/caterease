import 'package:equatable/equatable.dart';

/// Base Failure class
abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message ?? runtimeType.toString();
}

/// Server failure (e.g. backend error, wrong credentials, etc.)
class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

/// Network failure (e.g. no internet connection)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// Location failure (e.g. user denied location access)
class LocationFailure extends Failure {
  const LocationFailure([super.message]);
}

/// Permission failure (e.g. file storage, camera)
class PermissionFailure extends Failure {
  const PermissionFailure([super.message]);
}
/// Unexpected failure 
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message]);
}

class ServerException implements Exception {
  final String? message;

  ServerException([this.message]);

  @override
  String toString() => message ?? 'ServerException';
}
