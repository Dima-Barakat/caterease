
import "package:dartz/dartz.dart";
import "../../../../core/error/failures.dart";
import "../../../../core/usecases/usecase.dart";
import "../entities/restaurant.dart";
import "../repositories/restaurants_repository.dart";

class GetAllRestaurants implements UseCase<List<Restaurant>, NoParams> {
  final RestaurantsRepository repository;

  GetAllRestaurants(this.repository);

  @override
  Future<Either<Failure, List<Restaurant>>> call(NoParams params) async {
    return await repository.getAllRestaurants();
  }
}


