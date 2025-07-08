import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUserUseCase {
  final BaseAuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, Unit>> register(
    String name,
    String email,
    String password,
    String confirmationPassword,
    String phone,
    String gender,
  ) {
    return repository.register(
        name: name,
        email: email,
        password: password,
        confirmationPassword: confirmationPassword,
        phone: phone,
        gender: gender);
  }
}
