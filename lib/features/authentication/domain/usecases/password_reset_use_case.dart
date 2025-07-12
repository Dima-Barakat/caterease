import 'package:caterease/features/authentication/data/models/reset_password_model.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';

class PasswordResetUseCase {
  final BaseAuthRepository repository;

  PasswordResetUseCase(this.repository);

  Future<Either<Failure, ResetPasswordModel>> forgetPassword({
    required String email,
  }) async {
    return await repository.forgetPassword(email: email);
  }

  Future<Either<Failure, Unit>> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    return await repository.verifyOtp(userId: userId, otp: otp);
  }

  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await repository.resetPassword(
      email: email,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
