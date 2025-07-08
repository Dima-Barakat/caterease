import 'dart:convert';
import 'package:caterease/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/features/authentication/data/models/authentication_model.dart';

abstract class BaseAuthRemoteDataSource {
  Future<AuthenticationModel> login(String email, String password);
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
    required String confirmationPassword,
    required String phone,
    required String gender,
  });
}

class AuthRemoteDataSource implements BaseAuthRemoteDataSource {
  @override
  Future<AuthenticationModel> login(String email, String password) async {
    try {
      final formData = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return AuthenticationModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
    required String confirmationPassword,
    required String phone,
    required String gender,
  }) async {
    try {
      final formData = {
        'name': name,
        'email': email,
        'password': password,
        'confirmationPassword': confirmationPassword,
        'phone': phone,
        'gender': gender,
      };
      final uri = Uri.parse(ApiConstants.register);
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(formData));

      if (response.statusCode == 200) {
        print(response.body);
        return const Right(unit);
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Error during registration: $e');
    }
  }
}
