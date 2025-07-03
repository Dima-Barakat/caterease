
import "package:dartz/dartz.dart";
import "../../../../core/error/failures.dart";
import "../entities/restaurant.dart";

abstract class RestaurantsRepository {
  Future<Either<Failure, List<Restaurant>>> getNearbyRestaurants(
    double latitude,
    double longitude,
  );
  
  Future<Either<Failure, List<Restaurant>>> getAllRestaurants();
}


