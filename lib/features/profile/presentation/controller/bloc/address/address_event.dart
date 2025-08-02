
import 'package:equatable/equatable.dart';

sealed class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class GetAllAddressesEvent extends AddressEvent {}

class CreateAddressEvent extends AddressEvent {
  final String cityId;
  final String? street;
  final String? floor;
  final String? apartment;
  final String? building;
  final String? lat;
  final String? long;

  const CreateAddressEvent(
      {required this.cityId,
      this.street,
      this.floor,
      this.apartment,
      this.building,
      this.lat,
      this.long});
}

class DeleteAddressEvent extends AddressEvent {
  final int id;
  const DeleteAddressEvent({required this.id});
  @override
  List<Object> get props => [id];
}
