import 'package:caterease/features/address/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String name;
  final int phone;
  final String gender;
  final String? photo;
  final List<Address>? addresses;

  const User(
      {required this.id,
      required this.email,
      required this.name,
      required this.phone,
      required this.gender,
      this.photo,
      this.addresses});

  @override
  List<Object?> get props => [];
}
