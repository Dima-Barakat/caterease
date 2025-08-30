import "package:dartz/dartz.dart";
import "../../../../core/error/failures.dart";
import "../../../../core/usecases/usecase.dart";
import "../entities/restaurant.dart";
import "../repositories/restaurants_repository.dart";

class GetRestaurantsByCity implements UseCase<List<Restaurant>, CityParams> {
  final RestaurantsRepository repository;

  GetRestaurantsByCity(this.repository);

  @override
  Future<Either<Failure, List<Restaurant>>> call(CityParams params) async {
    return await repository.getRestaurantsByCity(params.cityId);
  }
}

class CityParams {
  final int cityId;

  CityParams({required this.cityId});
}

