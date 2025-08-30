import 'package:equatable/equatable.dart';

class NewAddress extends Equatable {
  final String type;
  final int newCityId;
  final String newStreet;
  final String newBuilding;
  final String newFloor;
  final String newApartment;
  final double newLatitude;
  final double newLongitude;

  const NewAddress({
    required this.type,
    required this.newCityId,
    required this.newStreet,
    required this.newBuilding,
    required this.newFloor,
    required this.newApartment,
    required this.newLatitude,
    required this.newLongitude,
  });

  @override
  List<Object?> get props => [
        type,
        newCityId,
        newStreet,
        newBuilding,
        newFloor,
        newApartment,
        newLatitude,
        newLongitude,
      ];
}


