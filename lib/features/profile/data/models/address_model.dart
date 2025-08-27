import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.city,
    super.street,
    super.building,
    super.floor,
    super.apartment,
    super.latitude,
    super.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      city: json['city'],
      street: json['street'] ?? '',
      building: json['building'] ?? '',
      floor: json['floor'] ?? '',
      apartment: json['apartment'] ?? '',
      latitude: json['latitude'] ?? '0.0',
      longitude: json['longitude'] ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      // 'country': country,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
