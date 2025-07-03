import "package:dartz/dartz.dart";
import "package:geolocator/geolocator.dart";
import "../../../../core/error/failures.dart";
import "../../domain/repositories/location_repository.dart";
import "../datasources/location_data_source.dart";

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      final position = await dataSource.getCurrentLocation();
      return Right(position);
    } catch (e) {
      // هنا ممكن تتحقق من نوع الخطأ إذا أردت، لكن في الغالب ترجع LocationFailure
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
}
