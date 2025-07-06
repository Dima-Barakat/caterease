import '../../data/models/authentication_model.dart';


abstract class BaseAuthRepository {
  Future<AuthenticationModel> login({
    required String email,
    required String password,
  });

  Future<AuthenticationModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String photo,
    required String gender,
  });
}
