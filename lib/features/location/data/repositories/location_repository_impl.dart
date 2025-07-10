import "package:caterease/features/location/data/datasources/send_location_remote_data_source.dart";
import "package:dartz/dartz.dart";
import "package:geolocator/geolocator.dart";
import "../../../../core/error/failures.dart";
import "../../domain/repositories/location_repository.dart";
import "../datasources/location_data_source.dart";

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;
  final SendLocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl({
    required this.dataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      final position = await dataSource.getCurrentLocation();
      return Right(position);
    } catch (e) {
      return Left(LocationFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermission() async {
    try {
      final granted = await dataSource.requestPermission();
      return granted ? Right(true) : Left(PermissionFailure());
    } catch (e) {
      return Left(PermissionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendLocation(
      double latitude, double longitude) async {
    try {
      await remoteDataSource.sendLocation(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
