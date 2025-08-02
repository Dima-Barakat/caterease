
import "package:dartz/dartz.dart";
import "package:geolocator/geolocator.dart";
import "../../../../core/error/failures.dart";
import "../../../../core/usecases/usecase.dart";
import "../repositories/location_repository.dart";

class GetCurrentLocation implements UseCase<Position, NoParams> {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, Position>> call(NoParams params) async {
    return await repository.getCurrentLocation();
  }
}


