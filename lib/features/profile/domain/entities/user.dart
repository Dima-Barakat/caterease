import 'package:caterease/features/profile/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String gender;
  final String? photo;
  final List<Address>? addresses;
  final Role? role;

  const User(
      {required this.id,
      required this.email,
      required this.name,
      required this.phone,
      required this.gender,
      this.photo,
      this.addresses,
      this.role});

  @override
  List<Object?> get props => [];
}

class Role extends Equatable {
  final int id;
  final String name;

  const Role({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [];
}
