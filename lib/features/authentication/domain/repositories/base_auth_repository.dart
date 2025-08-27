import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/authentication/data/models/reset_password_model.dart';
import 'package:caterease/features/profile/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/authentication_model.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, AuthenticationModel>> login(
      {required String email, required String password});

  Future<Either<Failure, UserModel>> register(
      {required String name,
      required String email,
      required String password,
      required String passwordConfirmation,
      required String phone,
      required String gender});

  Future<Either<Failure, Unit>> verifyEmail(
      {required String userId, required String otp});

  Future<Either<Failure, ResetPasswordModel>> forgetPassword(
      {required String email});

  Future<Either<Failure, Unit>> verifyOtp(
      {required String userId, required String otp});

  Future<Either<Failure, Unit>> resetPassword(
      {required String email,
      required String newPassword,
      required String confirmPassword});

  Future<Either<Failure, Unit>> logout();
}
