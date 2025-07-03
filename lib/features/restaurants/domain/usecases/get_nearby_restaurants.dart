
import "package:dartz/dartz.dart";
import "../../../../core/error/failures.dart";
import "../../../../core/usecases/usecase.dart";
import "../entities/restaurant.dart";
import "../repositories/restaurants_repository.dart";

class GetNearbyRestaurants implements UseCase<List<Restaurant>, LocationParams> {
  final RestaurantsRepository repository;

  GetNearbyRestaurants(this.repository);

  @override
  Future<Either<Failure, List<Restaurant>>> call(LocationParams params) async {
    return await repository.getNearbyRestaurants(
      params.latitude,
      params.longitude,
    );
  }
}

class LocationParams {
  final double latitude;
  final double longitude;

  LocationParams({required this.latitude, required this.longitude});
}


