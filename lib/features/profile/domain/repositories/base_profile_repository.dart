import 'package:caterease/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract class BaseProfileRepository {
  Future<Either<Failure, User>> getProfileDetails();
  Future<Either<Failure, User>> updateProfileDetails({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? photo,
  });
}
