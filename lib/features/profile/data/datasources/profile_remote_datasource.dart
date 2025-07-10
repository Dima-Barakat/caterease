import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // for MediaType

//! The abstract class
abstract class BaseProfileRemoteDatasource {
  Future<UserModel> getProfileDetails();

  Future<UserModel> updateProfileDetails(
      {String? name,
      String? email,
      String? phone,
      String? gender,
      String? photo});
}

//! Class Extends
class ProfileRemoteDatasource implements BaseProfileRemoteDatasource {
  @override
  Future<UserModel> getProfileDetails() async {
    try {
      final token = await SecureStorage().getAccessToken();

      final response = await http.get(
        Uri.parse(ApiConstants.customerProfile),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Authentication':'Bearer ${SecureStorage().getAccessToken()}'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      throw Exception('Error fetching profile data: $e');
    }
  }

  @override
  Future<UserModel> updateProfileDetails({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? photo,
  }) async {
    try {
      final token = await SecureStorage().getAccessToken();

      final uri = Uri.parse(ApiConstants.updateCustomerProfile);
      final request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json';

      if (name != null) request.fields['name'] = name;
      if (phone != null) request.fields['phone'] = phone;
      if (gender != null) request.fields['gender'] = gender;

      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            photo,
            filename: 'photo.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to update profile data');
      }
    } catch (e) {
      throw Exception('Error updating profile data: $e');
    }
  }
}
