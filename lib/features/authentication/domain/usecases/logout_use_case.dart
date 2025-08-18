import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase {
  final BaseAuthRepository repository;
  LogoutUseCase(this.repository);

  Future<Either<Failure, Unit>> logout() async {
    return await repository.logout();
  }
}
