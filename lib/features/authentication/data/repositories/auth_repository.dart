import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/models/authentication_model.dart';
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
    required String confirmationPassword,
    required String phone,
    required String gender,
  }) async {
    try {
      final user = await remoteDataSource.register(
          name: name,
          email: email,
          password: password,
          confirmationPassword: confirmationPassword,
          phone: phone,
          gender: gender);
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
}
