import 'dart:convert';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/data/models/reset_password_model.dart';
import 'package:caterease/features/profile/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
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
  final NetworkClient client;

  AuthRemoteDataSource(this.client);

  @override
  Future<AuthenticationModel> login(String email, String password) async {
    final formData = {
      'email': email,
      'password': password,
    };
    try {
      final response = await client.post(ApiConstants.login, body: formData);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        await SecureStorage().saveToken(decodedData['access_token']);
        return AuthenticationModel.fromJson(decodedData);
      } else {
        final error = jsonDecode(response.body);
        throw ServerException(
            error['original']['message'] ?? 'Unexpected error');
      }
    } catch (e) {
      return throw ServerException("Login Failed: $e");
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
      final response = await client.post(ApiConstants.register, body: formData);

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body)['user']);
      } else {
        final error = jsonDecode(response.body);
        throw ServerException(error['message'] ?? 'Unexpected error');
      }
    } catch (e) {
      return throw ServerException("Register failed: $e");
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
      final response =
          await client.post(ApiConstants.verifyOtp, body: formData);

      if (response.statusCode == 200) {
        return unit;
      } else {
        final error = jsonDecode(response.body);
        throw ServerException(error['message'] ?? 'Unexpected error');
      }
    } catch (e) {
      return throw ServerException("Email Verification failed: $e");
    }
  }

  @override
  Future<ResetPasswordModel> forgetPassword({required String email}) async {
    try {
      final formData = {'email': email};
      final response =
          await client.post(ApiConstants.forgetPassword, body: formData);

      if (response.statusCode == 200) {
        final data = ResetPasswordModel.fromJson(json.decode(response.body));
        SecureStorage().saveUserData(email: email, userId: data.userId);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw ServerException(error['message'] ?? 'Unexpected error');
      }
    } catch (e) {
      return throw ServerException("Forget password Request failed: $e");
    }
  }

  @override
  Future<Unit> verifyOtp({required String userId, required String otp}) async {
    try {
      final formData = {
        'user_id': userId,
        'otp': otp,
      };
      final response =
          await client.post(ApiConstants.verifyOtp, body: formData);

      if (response.statusCode == 200) {
        return unit;
      } else {
        final error = jsonDecode(response.body);
        throw ServerException(error['message'] ?? 'Unexpected error');
      }
    } catch (e) {
      return throw ServerException("OTP Verification failed: $e");
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
      final response =
          await client.post(ApiConstants.resetPassword, body: formData);

      if (response.statusCode == 200) {
        return unit;
      } else {
        final error = jsonDecode(response.body);
        throw ServerException(error['message'] ?? 'Unexpected error');
      }
    } catch (e) {
      return throw ServerException("Password Reset failed: $e");
    }
  }
}
