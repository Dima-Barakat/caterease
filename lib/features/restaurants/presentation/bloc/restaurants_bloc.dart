
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

  RestaurantsBloc({
    required this.getNearbyRestaurants,
    required this.getAllRestaurants,
  }) : super(RestaurantsInitial()) {
    on<LoadNearbyRestaurantsEvent>(_onLoadNearbyRestaurants);
    on<LoadAllRestaurantsEvent>(_onLoadAllRestaurants);
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


