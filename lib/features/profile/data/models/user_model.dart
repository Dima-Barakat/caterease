import 'package:caterease/features/profile/data/models/address_model.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id,
      required super.email,
      required super.name,
      required super.phone,
      required super.gender,
      super.photo,
      super.addresses,
      super.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      phone: json["phone"],
      gender: json["gender"],
      photo: json["photo"] != null ? json['photo'] : null,
      addresses: json['addresses'] != null
          ? List<AddressModel>.from(
              json['addresses']
                  .map((addressJson) => AddressModel.fromJson(addressJson)),
            )
          : null,
      role: json['role'] != null ? RoleModel.fromJson(json['role']) : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "phone": phone,
        "gender": gender,
        "photo": photo,
        "addresses": addresses != null
            ? List<dynamic>.from(
                addresses!.map((address) => (address as AddressModel).toJson()),
              )
            : null,
        "role": role != null ? (role as RoleModel).toJson() : null,
      };
}

class RoleModel extends Role {
  const RoleModel({
    required super.id,
    required super.name,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      RoleModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
