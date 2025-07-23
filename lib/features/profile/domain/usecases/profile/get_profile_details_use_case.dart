import 'package:caterease/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../../entities/user.dart';
import '../../repositories/base_profile_repository.dart';

class GetProfileDetailsUseCase {
  final BaseProfileRepository baseUserRepository;

  GetProfileDetailsUseCase(this.baseUserRepository);

  Future<Either<Failure, User>> getProfileDetails() async {
    return await baseUserRepository.getProfileDetails();
  }
}
