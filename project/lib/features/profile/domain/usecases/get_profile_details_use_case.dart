import '../entities/user.dart';
import '../repositories/base_user_repository.dart';

class GetProfileDetailsUseCase {
  final BaseUserRepository baseUserRepository;

  GetProfileDetailsUseCase(this.baseUserRepository);

  Future<User> getProfileDetails() async {
    return await baseUserRepository.getProfileDetails();
  }
}
