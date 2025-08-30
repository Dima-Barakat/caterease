import 'package:equatable/equatable.dart';

class Authentication extends Equatable {
  final String accessToken;
  final AuthenticationUser user;

  const Authentication({required this.accessToken, required this.user});

  @override
  List<Object?> get props => [accessToken, user];
}


class AuthenticationUser extends Equatable {
  final int id;
  final String name;
  final int roleId;
  final String phone;
  final String photo;
  final String gender;
  final String email;
  final String status;
  final String emailVerifiedAt;
  final int verified;

  const AuthenticationUser({
    required this.id,
    required this.name,
    required this.roleId,
    required this.phone,
    required this.photo,
    required this.gender,
    required this.email,
    required this.status,
    required this.emailVerifiedAt,
    required this.verified,
  });

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