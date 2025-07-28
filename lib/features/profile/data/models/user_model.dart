import 'package:caterease/features/profile/data/models/address_model.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id,
      required super.email,
      required super.name,
      required super.phone,
      required super.gender,
      required super.roleId,
      super.photo,
      super.addresses});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        gender: json["gender"],
        roleId: json["role_id"],
        photo: json["photo"] != null ? json['photo'] : null,
        addresses: json['addresses'] != null
            ? List<AddressModel>.from(
                json['addresses']
                    .map((addressJson) => AddressModel.fromJson(addressJson)),
              )
            : null,
      );
}
