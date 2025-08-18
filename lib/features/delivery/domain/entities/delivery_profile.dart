import 'package:caterease/features/profile/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class DeliveryProfile extends Equatable {
  final User user;
  final DeliveryPerson person;
  final Restaurant restaurant;
  final Branch branches;
  const DeliveryProfile({
    required this.user,
    required this.person,
    required this.restaurant,
    required this.branches,
  });

  @override
  List<Object> get props => [];
}

class DeliveryPerson extends Equatable {
  final int id;
  final int userId;
  final String vehicleType;
  final int isAvailable;

  const DeliveryPerson({
    required this.id,
    required this.userId,
    required this.isAvailable,
    required this.vehicleType,
  });
  @override
  List<Object> get props => [];
}

class Branch extends Equatable {
  final int id;
  final int restaurantId;
  final int managerId;
  final int cityId;
  final String description;
  final String photo;
  final String locationNote;
  final String latitude;
  final String longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Branch({
    required this.id,
    required this.restaurantId,
    required this.managerId,
    required this.cityId,
    required this.description,
    required this.photo,
    required this.locationNote,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [];
}

class Restaurant extends Equatable {
  final int id;
  final String name;
  final String description;
  final String photo;
  final int ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isActive;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  @override
  List<Object> get props => [];
}
