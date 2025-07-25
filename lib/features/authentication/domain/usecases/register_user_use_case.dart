import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:caterease/features/profile/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class RegisterUserUseCase {
  final BaseAuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, UserModel>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String phone,
    String gender,
  ) async {
    return await repository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        gender: gender);
  }
}
