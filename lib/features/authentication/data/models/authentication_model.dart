import 'package:caterease/features/authentication/domain/entities/authentication.dart';

class AuthenticationModel extends Authentication {
  const AuthenticationModel({required super.accessToken, required super.user});

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationModel(
          accessToken: json['access_token'],
          user: AuthenticationUserModel.fromJson(json['user']));
}

class AuthenticationUserModel extends AuthenticationUser {
  const AuthenticationUserModel({
    required super.id,
    required super.name,
    required super.roleId,
    required super.phone,
    required super.photo,
    required super.gender,
    required super.email,
    required super.status,
    required super.emailVerifiedAt,
    required super.verified,
  });

  factory AuthenticationUserModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationUserModel(
      id: json['id'],
      name: json['name'],
      roleId: json['role_id'],
      phone: json['phone'],
      photo: json['photo'],
      gender: json['gender'],
      email: json['email'],
      status: json['status'],
      emailVerifiedAt: json['email_verified_at'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role_id': roleId,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'email': email,
      'status': status,
      'email_verified_at': emailVerifiedAt,
      'verified': verified,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        roleId,
        phone,
        photo,
        gender,
        email,
        status,
        emailVerifiedAt,
        verified,
      ];
}
