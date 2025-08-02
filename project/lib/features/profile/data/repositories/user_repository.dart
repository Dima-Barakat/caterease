import 'package:caterease/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:caterease/features/profile/data/models/user_model.dart';
import 'package:caterease/features/profile/domain/repositories/base_user_repository.dart';

class UserRepository implements BaseUserRepository {
  final BaseProfileRemoteDatasource baseProfileRemoteDatasource;
  UserRepository(this.baseProfileRemoteDatasource);

  @override
  Future<UserModel> getProfileDetails() async {
    return await baseProfileRemoteDatasource.getProfileDetails();
  }

  @override
  Future<UserModel> updateProfileDetails({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? photo,
  }) async {
    return await baseProfileRemoteDatasource.updateProfileDetails(
      name: name,
      phone: phone,
      gender: gender,
      photo: photo,
    );
  }
}
