import 'dart:convert';
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
    //final token = await storage.read(key: 'token');
    const token = 'Bearer 2|wXnBBvtboZdhN2rcWPGXcxCwDL0hqAZ034kjOhPW45936c9d';
    final url = Uri.parse('http://192.168.0.106:8000/api/customer/creat');
    print('📦 Token: $token');
    final response = await http.post(
      url,
      headers: {
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
      print("✅ Location sent successfully");
      print("Response: ${response.body}");
    } else {
      print("❌ Failed to send location: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  }
}
