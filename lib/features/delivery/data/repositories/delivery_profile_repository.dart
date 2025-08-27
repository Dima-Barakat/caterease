import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/data/datasources/delivery_profile_remote_data_source.dart';
import 'package:caterease/features/delivery/data/models/delivery_profile_model.dart';
import 'package:caterease/features/delivery/domain/repositories/base_delivery_profile_repository.dart';
import 'package:dartz/dartz.dart';

class DeliveryProfileRepository implements BaseDeliveryProfileRepository {
  final BaseDeliveryProfileRemoteDataSource dataSource;

  DeliveryProfileRepository(this.dataSource);

  @override
  Future<Either<Failure, DeliveryProfileModel>> getProfile() async {
    try {
      final response = await dataSource.getProfile();
      return Right(response);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else {
        return Left(UnexpectedFailure("Unexpected error: ${e.toString()}"));
      }
    }
  }
}
