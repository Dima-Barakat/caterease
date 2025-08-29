import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final int? cityId;
  final int? areaId;
  final int? districtId;
  final String? area;
  final String? city;
  final String? district;
  final String? street;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? latitude;
  final String? longitude;

  const Address({
    required this.id,
    required this.cityId,
    this.city,
    this.areaId,
    this.area,
    this.districtId,
    this.district,
    this.street,
    this.building,
    this.floor,
    this.apartment,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        cityId,
        city,
        area,
        areaId,
        district,
        districtId,
        street,
        building,
        floor,
        apartment,
        latitude,
        longitude
      ];
}
