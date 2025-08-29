import 'dart:convert';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NetworkClient {
  final http.Client client;
  final FlutterSecureStorage storage;

  NetworkClient(this.client, this.storage);

  //: Headers
  Future<Map<String, String>> _getHeaders() async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();

    if (kDebugMode) print("→ token from storage: $token");

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.trim().isNotEmpty)
        'Authorization': 'Bearer $token', //! 'Bearer $token'
    };
  }

  //: Handle response for all requests
  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      if (kDebugMode) print("⚠️ 401 detected: Token expired");

      await SecureStorage().clearAll();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
    if (kDebugMode) print(response.statusCode);
    if (kDebugMode) print(response.body);
    return response;
  }

  //: Get Request
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final defaultHeaders = await _getHeaders();

    if (kDebugMode) print('>> REQUEST URL: $url');
    if (kDebugMode) print('>> REQUEST HEADERS: $defaultHeaders');

    final response = await client.get(
      Uri.parse(url),
      headers: {...defaultHeaders, ...?headers},
    );
    return _handleResponse(response);
  }

  //: Post Request
  Future<http.Response> post(String url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final defaultHeaders = await _getHeaders();

    if (kDebugMode) print('>> REQUEST URL: $url');
    if (kDebugMode) print('>> REQUEST HEADERS: $defaultHeaders');

    if (kDebugMode) {
      print('>> REQUEST BODY: ${body != null ? jsonEncode(body) : null}');
    }

    final response = await client.post(
      Uri.parse(url),
      headers: {...defaultHeaders, ...?headers},
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response);
  }

  //: Delete Request
  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    final defaultHeaders = await _getHeaders();

    if (kDebugMode) print('>> REQUEST URL: $url');
    if (kDebugMode) print('>> DELETE REQUEST HEADERS: $defaultHeaders');

    final response = await client.delete(
      Uri.parse(url),
      headers: {...defaultHeaders, ...?headers},
    );

    return _handleResponse(response);
  }
}
