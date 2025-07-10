part of "restaurants_bloc.dart";

abstract class RestaurantsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadNearbyRestaurantsEvent extends RestaurantsEvent {
  final double latitude;
  final double longitude;

  LoadNearbyRestaurantsEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class GetRestaurantsByCategoryEvent extends RestaurantsEvent {
  final String category;

  GetRestaurantsByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class LoadAllRestaurantsEvent extends RestaurantsEvent {}
