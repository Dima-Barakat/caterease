import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel(
      {required super.id,
      required super.userId,
      required super.cityId,
      required super.city,
      required super.street,
      required super.building,
      required super.floor,
      required super.apartment,
      required super.latitude,
      required super.longitude,
      required super.isDefault});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      userId: json['user_id'],
      cityId: json['city_id'],
      city: json['city'],
      street: json['street'],
      building: json['building'],
      floor: json['floor'],
      apartment: json['apartment'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDefault: json['is_default'],
    );
  }
}
