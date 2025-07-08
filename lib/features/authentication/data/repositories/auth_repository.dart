import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/models/authentication_model.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepository implements BaseAuthRepository {
  final BaseAuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  @override
  Future<AuthenticationModel> login(
      {required String email, required String password}) async {
    try {
      final authentication = await remoteDataSource.login(email, password);
      await SecureStorage().saveTokens(authentication.accessToken);
      return authentication;
    } catch (e) {
      print(e);
      throw Exception('Error fetching profile data: $e');
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
    required String confirmationPassword,
    required String phone,
    required String gender,
  }) async {
    try {
      return await remoteDataSource.register(
          name: name,
          email: email,
          password: password,
          confirmationPassword: confirmationPassword,
          phone: phone,
          gender: gender);
    } catch (e) {
      print(e);
      throw Exception('Error fetching Registering: $e');
    }
  }
}
