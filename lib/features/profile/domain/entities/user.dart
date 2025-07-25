import 'package:caterease/features/profile/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String gender;
  final String? photo;
  final String? role;
  final List<Address>? addresses;

  const User(
      {required this.id,
      required this.email,
      required this.name,
      required this.phone,
      required this.gender,
      this.photo,
      this.role,
      this.addresses});

  @override
  List<Object?> get props => [];
}
