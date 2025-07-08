import 'package:caterease/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/authentication_model.dart';

abstract class BaseAuthRepository {
  Future<AuthenticationModel> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
    required String confirmationPassword,
    required String phone,
    required String gender,
  });
}
