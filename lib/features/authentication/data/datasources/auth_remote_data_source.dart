import 'dart:convert';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/data/models/reset_password_model.dart';
import 'package:caterease/features/profile/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/features/authentication/data/models/authentication_model.dart';

abstract class BaseAuthRemoteDataSource {
  Future<AuthenticationModel> login(String email, String password);

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
  });

  Future<Unit> verifyEmail({required String userId, required String otp});

  Future<ResetPasswordModel> forgetPassword({required String email});

  Future<Unit> verifyOtp({required String userId, required String otp});

  Future<Unit> resetPassword(
      {required String email,
      required String newPassword,
      required String confirmPassword});
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
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String gender,
  }) async {
    try {
      final formData = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
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
        final responseData = json.decode(response.body);
        SecureStorage().saveUserData(
          email: responseData['user']['email'],
          userId: responseData['user']['id'],
          name: responseData['user']['name'],
        );
        print(response.body);
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  @override
  Future<Unit> verifyEmail(
      {required String userId, required String otp}) async {
    try {
      final formData = {
        'user_id': userId,
        'otp': otp,
      };
      final response = await http.post(
        Uri.parse(ApiConstants.verifyOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'Authentication':'Bearer 17|asjefjhcsHVasgjhyvfasjvfasjcsdv'
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return unit;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error during Verifying Email: $e');
    }
  }

  @override
  Future<ResetPasswordModel> forgetPassword({required String email}) async {
    try {
      final formData = {'email': email};
      final response = await http.post(Uri.parse(ApiConstants.forgetPassword),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(formData));

      if (response.statusCode == 200) {
        print(response.body);
        return ResetPasswordModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error during Verifying Email: $e');
    }
  }

  @override
  Future<Unit> verifyOtp({required String userId, required String otp}) async {
    try {
      final formData = {
        'user_id': userId,
        'otp': otp,
      };
      final response = await http.post(
        Uri.parse(ApiConstants.verifyOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return unit;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error during OTP Verification: $e');
    }
  }

  @override
  Future<Unit> resetPassword(
      {required String email,
      required String newPassword,
      required String confirmPassword}) async {
    try {
      final formData = {
        'email': email,
        'newPassword': newPassword,
        'newPassword_confirmation': confirmPassword,
      };
      final response = await http.post(Uri.parse(ApiConstants.resetPassword),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(formData));

      if (response.statusCode == 200) {
        print(response.body);
        return unit;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error during Resetting Password: $e');
    }
  }
}
