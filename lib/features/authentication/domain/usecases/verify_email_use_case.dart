import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/usecases/usecase.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyEmailUseCase {
  final BaseAuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<Failure, Unit>> verifyEmail(String userId, String otp) async {
    return await repository.verifyEmail(userId: userId, otp: otp);
  }
}
