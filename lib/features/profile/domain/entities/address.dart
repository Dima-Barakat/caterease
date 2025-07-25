import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final String city;
  final String? street;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? latitude;
  final String? longitude;
//  final int isDefault;

  const Address({
    required this.id,
    required this.city,
    this.street,
    this.building,
    this.floor,
    this.apartment,
    this.latitude,
    this.longitude,
    //required this.isDefault
  });

  @override
  List<Object?> get props => [];
}
