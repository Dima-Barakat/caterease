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
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "city_id": "1",
        "district_id": "5", // مثال - يجب وضع ID صحيح
        "area_id": "5",
        "street": "test street",
        "building": "B12",
        "floor": "3",
        "apartment": "10",
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      }),
    );

    print("URL: $url");
    print("Status Code: ${response.statusCode}");
    print("Headers: ${response.headers}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      print(" ***Location sent successfully");
    } else {
      print(" *****Failed to send location");
    }
  }
}
