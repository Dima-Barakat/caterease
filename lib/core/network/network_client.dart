import 'dart:convert';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkClient {
  final http.Client client;
  final FlutterSecureStorage storage;

  NetworkClient(this.client, this.storage);

  Future<Map<String, String>> _getHeaders() async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();

    print('→ token from storage: "$token"');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.trim().isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final defaultHeaders = await _getHeaders();
    return await client.get(
      Uri.parse(url),
      headers: {...defaultHeaders, ...?headers},
    );
  }

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final defaultHeaders = await _getHeaders();

    // ← هنا اطبع الهيدر والـ body قبل الإرسال
    print('>> REQUEST HEADERS: $defaultHeaders');
    print('>> REQUEST BODY: ${body != null ? jsonEncode(body) : null}');

    return await client.post(
      Uri.parse(url),
      headers: {...defaultHeaders, ...?headers},
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    final defaultHeaders = await _getHeaders();
    print('>> DELETE REQUEST HEADERS: $defaultHeaders');
    print('>> DELETE REQUEST URL: $url');

    return await client.delete(
      Uri.parse(url),
      headers: {...defaultHeaders, ...?headers},
    );
  }
}
