import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/features/authentication/data/models/authentication_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthenticationModel> login(String email, String password);
  Future<AuthenticationModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String photo,
    required String gender,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
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
Future<AuthenticationModel> register({
  required String name,
  required String email,
  required String password,
  required String phone,
  required String photo,
  required String gender,
}) async {
  try {
    final uri = Uri.parse(ApiConstants.register);
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['phone'] = phone
      ..fields['gender'] = gender;

    // Add the photo file if it exists
    if (photo.isNotEmpty && File(photo).existsSync()) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photo,
          filename: 'photo.jpg',
          //contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return AuthenticationModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error during registration: $e');
  }
}
}
