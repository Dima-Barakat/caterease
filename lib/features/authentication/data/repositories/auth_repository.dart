// ignore_for_file: avoid_print

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
  SecureStorage secureStorage = SecureStorage();

  AuthRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, AuthenticationModel>> login(
      {required String email, required String password}) async {
    try {
      final authentication = await remoteDataSource.login(email, password);

      //:Save data to storage
      await secureStorage.saveToken(authentication.accessToken);
      await secureStorage.saveUserData(
          userId: authentication.user.id,
          email: authentication.user.email,
          name: authentication.user.name,
          roleId: authentication.user.roleId);
      return Right(authentication);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure("Unexpected error: $e"));
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
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail(
      {required String userId, required String otp}) async {
    try {
      final unit = await remoteDataSource.verifyEmail(userId: userId, otp: otp);
      return Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure("Unexpected error: $e"));
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
      return Right(resetPasswordModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure("Unexpected error: $e"));
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
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure("Unexpected error: $e"));
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
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      final response = await remoteDataSource.logout();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure("Unexpected error: $e"));
    }
  }
}
