import "dart:convert";
import "../../../../core/constants/api_constants.dart";
import "../../../../core/network/network_client.dart";
import "../models/restaurant_model.dart";

abstract class RestaurantsRemoteDataSource {
  Future<List<RestaurantModel>> getNearbyRestaurants(
    double latitude,
    double longitude,
  );
  Future<List<RestaurantModel>> getAllRestaurants();

  // الجديد - إضافة method للفلترة حسب المحافظة
  Future<List<RestaurantModel>> getRestaurantsByCity(int cityId);
}

class RestaurantsRemoteDataSourceImpl implements RestaurantsRemoteDataSource {
  final NetworkClient client;

  RestaurantsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RestaurantModel>> getNearbyRestaurants(
    double latitude,
    double longitude,
  ) async {
    final response = await client.get(
      "${ApiConstants.baseUrl}${ApiConstants.nearbyBranches}?lat=$latitude&lng=$longitude",
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> restaurants = responseData["data"];

      return restaurants.map((json) => RestaurantModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load nearby restaurants");
    }
  }

  @override
  Future<List<RestaurantModel>> getAllRestaurants() async {
    final response = await client.get(
      "${ApiConstants.baseUrl}${ApiConstants.restaurants}",
    );

    if (response.statusCode == 200) {
      final List<dynamic> restaurants = json.decode(response.body);

      return restaurants.map((json) => RestaurantModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  // الجديد - تنفيذ API call للفلترة حسب المحافظة
  @override
  Future<List<RestaurantModel>> getRestaurantsByCity(int cityId) async {
    final response = await client.get(
      "${ApiConstants.baseUrl}/branches/nearby?city_id=$cityId",
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> restaurants = responseData["data"];

      return restaurants.map((json) => RestaurantModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load restaurants by city");
    }
  }
}
