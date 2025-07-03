
import "../../domain/entities/restaurant.dart";

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.photo,
    required super.rating,
    required super.totalRatings,
    super.distance,
    super.city,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json["restaurant_id"] ?? json["id"],
      name: json["restaurant"]?["name"] ?? json["name"],
      description: json["restaurant"]?["description"] ?? json["description"],
      photo: json["restaurant"]?["photo"] ?? json["photo"],
      rating: (json["rating"] ?? 0).toDouble(),
      totalRatings: json["total_ratings"] ?? 0,
      distance: json["distance"]?.toDouble(),
      city: json["city"] != null ? CityModel.fromJson(json["city"]) : null,
    );
  }
}

class CityModel extends City {
  const CityModel({
    required super.id,
    required super.name,
    required super.country,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json["id"],
      name: json["name"],
      country: json["country"],
    );
  }
}


