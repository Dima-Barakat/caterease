import '../entities/user.dart';
import '../repositories/base_user_repository.dart';

class UpdateProfileUseCase {
  final BaseUserRepository baseUserRepository;

  const UpdateProfileUseCase(this.baseUserRepository);

  Future<User> updateProfileDetails({
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
