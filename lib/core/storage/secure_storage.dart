import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  Future<void> saveTokens(
    String accessToken,
  ) async {
    await storage.write(key: 'access_token', value: accessToken);
  }

  Future<void> saveUserData(
      {required int userId,
      required String email,
      String? name}) async {
    await storage.write(key: 'user_id', value: userId.toString());
    await storage.write(key: 'email', value: email.toString());
  }

  Future<String?> getAccessToken() async =>
      await storage.read(key: 'access_token');
  Future<String?> getUserId() => storage.read(key: "user_id");

// Clear all data on logout
  Future<void> clearAll() async => await storage.deleteAll();
}
