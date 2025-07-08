import 'package:caterease/features/authentication/domain/entities/authentication.dart';
import 'package:caterease/features/profile/data/models/user_model.dart';

class AuthenticationModel extends Authentication {
  const AuthenticationModel({required super.accessToken, required super.user});

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationModel(
          accessToken: json['access_token'],
          user: UserModel.fromJson(json['user']));
}
