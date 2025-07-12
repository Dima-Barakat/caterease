import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/models/authentication_model.dart';
import 'package:caterease/features/authentication/data/models/reset_password_model.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:caterease/features/profile/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class AuthRepository implements BaseAuthRepository {
  final BaseAuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, AuthenticationModel>> login(
      {required String email, required String password}) async {
    try {
      final authentication = await remoteDataSource.login(email, password);
      await SecureStorage().saveTokens(authentication.accessToken);
      return Right(authentication);
    } catch (e) {
      throw Exception('Error fetching profile data: $e');
    }
  }

  @override
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
  }) async {
    try {
      final user = await remoteDataSource.register(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          phone: phone,
          gender: gender);
      await SecureStorage().saveUserData(userId: user.id, email: email);
      return Right(user);
    } catch (e) {
      throw Exception('Error fetching Registering: $e');
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail(
      {required String userId, required String otp}) async {
    try {
      final unit = await remoteDataSource.verifyEmail(userId: userId, otp: otp);
      return Right(unit);
    } catch (e) {
      throw Exception('Error fetching Verifying Email: $e');
    }
  }

  @override
  Future<Either<Failure, ResetPasswordModel>> forgetPassword(
      {required String email}) async {
    try {
      final resetPasswordModel =
          await remoteDataSource.forgetPassword(email: email);
      await SecureStorage()
          .saveUserData(userId: resetPasswordModel.userId, email: email);
      print(resetPasswordModel.userId);
      print(resetPasswordModel.userId);
      print(resetPasswordModel.userId);
      print(resetPasswordModel.userId);
      print(resetPasswordModel.userId);
      print(resetPasswordModel.userId);
      return Right(resetPasswordModel);
    } catch (e) {
      throw Exception('Error fetching Forgetting Password: $e');
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    try {
      final unit = await remoteDataSource.verifyOtp(userId: userId, otp: otp);
      return Right(unit);
    } catch (e) {
      throw Exception('Error fetching OTP Verification: $e');
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final unit = await remoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return Right(unit);
    } catch (e) {
      throw Exception('Error fetching Resetting Password: $e');
    }
  }
}
