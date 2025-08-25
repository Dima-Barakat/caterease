import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:caterease/features/profile/data/models/user_model.dart';
import 'package:caterease/features/profile/domain/repositories/base_profile_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepository implements BaseProfileRepository {
  final BaseProfileRemoteDatasource baseProfileRemoteDatasource;
  UserRepository(this.baseProfileRemoteDatasource);

  @override
  Future<Either<Failure, UserModel>> getProfileDetails() async {
    final user = await baseProfileRemoteDatasource.getProfileDetails();
    return Right(user);
  }

  @override
  Future<Either<Failure, UserModel>> updateProfileDetails({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? photo,
  }) async {
    final user = await baseProfileRemoteDatasource.updateProfileDetails(
      name: name,
      email: email,
      phone: phone,
      gender: gender,
      photo: photo,
    );
    return Right(user);
  }
}
