import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/models/authentication_model.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';

class AuthRepository implements BaseAuthRepository {
  final AuthRemoteDataSource remoteDataSource;

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
  Future<AuthenticationModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String photo,
    required String gender,
  }) async {
    final user = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        photo: photo,
        gender: gender);
    return user;
  }
}
