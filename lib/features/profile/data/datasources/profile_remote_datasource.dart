import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // for MediaType

abstract class BaseProfileRemoteDatasource {
  Future<UserModel> getProfileDetails();

  Future<UserModel> updateProfileDetails(
      {String? name,
      String? email,
      String? phone,
      String? gender,
      String? photo});
}

class ProfileRemoteDatasource implements BaseProfileRemoteDatasource {
  final NetworkClient client;
  ProfileRemoteDatasource(this.client);

  @override
  Future<UserModel> getProfileDetails() async {
    try {
      final response = await client.get(ApiConstants.customerProfile);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['data']);
        return UserModel.fromJson(data['data']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Unexpected Error');
      }
    } catch (e) {
      throw Exception('Error fetching profile data:\n $e');
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
      final request = http.MultipartRequest('POST', uri)
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
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['data']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Unexpected error');
      }
    } catch (e) {
      throw Exception('Error updating profile data: \n $e');
    }
  }
}
