import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    super.cityId,
    super.city,
    super.areaId,
    super.districtId,
    super.area,
    super.district,
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
      cityId: json['cityId'],
      areaId: json['areaId'],
      districtId: json['districtId'],
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      street: json['street'] ?? '',
      building: json['building'] ?? '',
      floor: json['floor'] ?? '',
      apartment: json['apartment'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'areaId': areaId,
      'cityId': cityId,
      'districtId': districtId,
      'area': area,
      'city': city,
      'district': district,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
