import 'package:caterease/features/delivery/domain/entities/delivery_profile.dart';

import 'package:caterease/features/profile/data/models/user_model.dart';

class DeliveryProfileModel extends DeliveryProfile {
  const DeliveryProfileModel({
    required UserModel user,
    required DeliveryPersonModel person,
    required RestaurantModel restaurant,
    required BranchModel branches,
  }) : super(
          user: user,
          person: person,
          restaurant: restaurant,
          branches: branches,
        );

  factory DeliveryProfileModel.fromJson(Map<String, dynamic> json) {
    return DeliveryProfileModel(
      user: UserModel.fromJson(json['user']),
      person: DeliveryPersonModel.fromJson(json['delivery_person']),
      restaurant: RestaurantModel.fromJson(json['restaurants']),
      branches: BranchModel.fromJson(json['branches']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": (user as UserModel).toJson(),
      "person": (person as DeliveryPersonModel).toJson(),
      "restaurants": (restaurant as RestaurantModel).toJson(),
      "branches": (branches as BranchModel).toJson(),
    };
  }
}

class DeliveryPersonModel extends DeliveryPerson {
  const DeliveryPersonModel({
    required int id,
    required int userId,
    required int isAvailable,
    required String vehicleType,
  }) : super(
          id: id,
          userId: userId,
          isAvailable: isAvailable,
          vehicleType: vehicleType,
        );

  factory DeliveryPersonModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPersonModel(
      id: json['id'],
      userId: json['user_id'],
      isAvailable: json['is_available'],
      vehicleType: json['vehicle_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "is_available": isAvailable,
      "vehicle_type": vehicleType,
    };
  }
}

class BranchModel extends Branch {
  const BranchModel({
    required super.id,
    required super.restaurantId,
    required super.managerId,
    required super.cityId,
    required super.description,
    required super.photo,
    required super.locationNote,
    required super.latitude,
    required super.longitude,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      managerId: json['manager_id'],
      cityId: json['city_id'],
      description: json['description'],
      photo: json['photo'],
      locationNote: json['location_note'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "restaurant_id": restaurantId,
      "manager_id": managerId,
      "city_id": cityId,
      "description": description,
      "photo": photo,
      "location_note": locationNote,
      "latitude": latitude,
      "longitude": longitude,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.photo,
    required super.ownerId,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
      ownerId: json['owner_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "photo": photo,
      "owner_id": ownerId,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "is_active": isActive,
    };
  }
}
