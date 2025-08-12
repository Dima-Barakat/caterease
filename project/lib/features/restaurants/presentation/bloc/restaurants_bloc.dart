import "package:caterease/features/restaurants/data/models/branch_model.dart";
import "package:caterease/features/restaurants/domain/repositories/restaurants_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:equatable/equatable.dart";
import "../../../../core/usecases/usecase.dart";
import "../../domain/entities/restaurant.dart";
import "../../domain/usecases/get_nearby_restaurants.dart";
import "../../domain/usecases/get_all_restaurants.dart";

part "restaurants_event.dart";
part "restaurants_state.dart";

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final GetNearbyRestaurants getNearbyRestaurants;
  final GetAllRestaurants getAllRestaurants;
  final RestaurantsRepository repo;

  RestaurantsBloc({
    required this.getNearbyRestaurants,
    required this.getAllRestaurants,
    required this.repo,
  }) : super(RestaurantsInitial()) {
    on<LoadNearbyRestaurantsEvent>(_onLoadNearbyRestaurants);
    on<LoadAllRestaurantsEvent>(_onLoadAllRestaurants);

    on<GetRestaurantsByCategoryEvent>((event, emit) async {
      emit(RestaurantsLoading());
      try {
        print('📡 Fetching category: ${event.category}');
        final restaurants = await repo.getBranchesByCategory(event.category);
        print('✅ Received: ${restaurants.length} items');
        emit(RestaurantsByCategoryLoaded(restaurants));
      } catch (e, s) {
        print('❌ Error loading category: $e');
        print(s);
        emit(RestaurantsError('Failed to load restaurants: ${e.toString()}'));
      }
    });
  }

  Future<void> _onLoadNearbyRestaurants(
    LoadNearbyRestaurantsEvent event,
    Emitter<RestaurantsState> emit,
  ) async {
    emit(RestaurantsLoading());

    final result = await getNearbyRestaurants(
      LocationParams(latitude: event.latitude, longitude: event.longitude),
    );

    result.fold(
      (failure) => emit(RestaurantsError("فشل في تحميل المطاعم القريبة")),
      (restaurants) => emit(RestaurantsLoaded(restaurants)),
    );
  }

  Future<void> _onLoadAllRestaurants(
    LoadAllRestaurantsEvent event,
    Emitter<RestaurantsState> emit,
  ) async {
    emit(RestaurantsLoading());

    final result = await getAllRestaurants(NoParams());

    result.fold(
      (failure) => emit(RestaurantsError("فشل في تحميل المطاعم")),
      (restaurants) => emit(RestaurantsLoaded(restaurants)),
    );
  }
}
