import 'dart:convert';
import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SendLocationRemoteDataSource {
  Future<void> sendLocation({
    required double latitude,
    required double longitude,
  });
}

class SendLocationRemoteDataSourceImpl implements SendLocationRemoteDataSource {
  final http.Client client;

  SendLocationRemoteDataSourceImpl({required this.client});
  final storage = FlutterSecureStorage();

  @override
  Future<void> sendLocation({
    required double latitude,
    required double longitude,
  }) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();
    final url = Uri.parse('${ApiConstants.baseUrl}/customer/creat');
    print(' Token: $token');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "city_id": "1",
        "street": "test street",
        "building": "B12",
        "floor": "3",
        "apartment": "10",
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      }),
    );

    if (response.statusCode == 201) {
      print(" ***Location sent successfully");
      print("Response: ${response.body}");
    } else {
      print(" *****Failed to send location: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  }
}
