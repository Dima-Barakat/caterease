
import "package:dartz/dartz.dart";
import "../../../../core/error/failures.dart";
import "../../domain/entities/restaurant.dart";
import "../../domain/repositories/restaurants_repository.dart";
import "../datasources/restaurants_remote_data_source.dart";

class RestaurantsRepositoryImpl implements RestaurantsRepository {
  final RestaurantsRemoteDataSource remoteDataSource;

  RestaurantsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Restaurant>>> getNearbyRestaurants(
    double latitude,
    double longitude,
  ) async {
    try {
      final restaurants = await remoteDataSource.getNearbyRestaurants(
        latitude,
        longitude,
      );
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Restaurant>>> getAllRestaurants() async {
    try {
      final restaurants = await remoteDataSource.getAllRestaurants();
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}


