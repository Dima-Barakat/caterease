import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int id;
  final int userId;
  final int cityId;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String apartment;
  final String latitude;
  final String longitude;
  final int isDefault;

  const Address(
      {required this.id,
      required this.userId,
      required this.cityId,
      required this.city,
      required this.street,
      required this.building,
      required this.floor,
      required this.apartment,
      required this.latitude,
      required this.longitude,
      required this.isDefault});
 
  @override
  List<Object?> get props => [];
}
