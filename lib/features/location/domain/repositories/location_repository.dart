
import "package:dartz/dartz.dart";
import "package:geolocator/geolocator.dart";
import "../../../../core/error/failures.dart";

abstract class LocationRepository {
  Future<Either<Failure, Position>> getCurrentLocation();
  Future<Either<Failure, bool>> requestPermission();
}


