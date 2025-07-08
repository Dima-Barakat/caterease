import 'package:caterease/features/authentication/data/models/authentication_model.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';

class LoginUserUseCase {
  final BaseAuthRepository repository;

  LoginUserUseCase(this.repository);

  Future<AuthenticationModel> login(String email, String password) async{
    return await repository.login(email: email, password: password);
  }
}
