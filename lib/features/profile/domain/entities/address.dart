import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final String city;
  // final String? country;
  final String? street;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? latitude;
  final String? longitude;

  const Address({
    required this.id,
    required this.city,
    // this.country,
    this.street,
    this.building,
    this.floor,
    this.apartment,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [];
}
