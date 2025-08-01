import 'package:caterease/features/authentication/domain/entities/authentication.dart';

class AuthenticationModel extends Authentication {
  const AuthenticationModel({required super.accessToken});

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationModel(
        accessToken: json['access_token'],
      );
}
