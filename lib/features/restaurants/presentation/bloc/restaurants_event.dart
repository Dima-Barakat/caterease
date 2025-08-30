part of "restaurants_bloc.dart";

abstract class RestaurantsEvent extends Equatable {
  const RestaurantsEvent();

  @override
  List<Object> get props => [];
}

class LoadNearbyRestaurantsEvent extends RestaurantsEvent {
  final double latitude;
  final double longitude;

  const LoadNearbyRestaurantsEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class GetRestaurantsByCategoryEvent extends RestaurantsEvent {
  final String category;

  const GetRestaurantsByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class LoadAllRestaurantsEvent extends RestaurantsEvent {}

// الجديد - إضافة event للفلترة حسب المحافظة
class LoadRestaurantsByCityEvent extends RestaurantsEvent {
  final int cityId;

  const LoadRestaurantsByCityEvent({required this.cityId});

  @override
  List<Object> get props => [cityId];
}

