import '../entities/user.dart';

abstract class BaseUserRepository {
  Future<User> getProfileDetails();
  Future<User> updateProfileDetails({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? photo,
  });
}
