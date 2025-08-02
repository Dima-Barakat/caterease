import 'package:caterease/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../../entities/user.dart';
import '../../repositories/base_profile_repository.dart';

class UpdateProfileUseCase {
  final BaseProfileRepository baseUserRepository;

  const UpdateProfileUseCase(this.baseUserRepository);

  Future<Either<Failure, User>> updateProfileDetails({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? photo,
  }) async {
    return await baseUserRepository.updateProfileDetails(
      name: name,
      email: email,
      phone: phone,
      gender: gender,
      photo: photo,
    );
  }
}
