import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  //: Write the Access-Token to the storage
  Future<void> saveToken(String accessToken) async {
    await storage.write(key: 'access_token', value: accessToken);
  }

  //: Write Important user data to the storage
  Future<void> saveUserData(
      {required int userId,
      required String email,
      String? name,
      int? roleId}) async {
    await storage.write(key: 'user_id', value: userId.toString());
    await storage.write(key: 'email', value: email.toString());
    await storage.write(key: 'role', value: roleId.toString());
    await storage.write(key: 'name', value: name.toString());
  }

  //: Save Device Token
  Future<void> saveDeviceToken(String? deviceToken) async {
    if (deviceToken != null) {
      await storage.write(key: 'device_token', value: deviceToken);
    }
  }

  //: Read the Access-Token from the storage
  Future<String?> getAccessToken() async =>
      await storage.read(key: 'access_token');

  //: Read the User-id from the storage
  Future<String?> getUserId() async => await storage.read(key: "user_id");

  //: Read the User's Email from the storage
  Future<String?> getEmail() async => await storage.read(key: "email");

  //: Read the User's Role from the storage
  Future<String?> getRole() async => await storage.read(key: "role");

  //: Read Device Token
  Future<String?> getDeviceToken() async =>
      await storage.read(key: "device_token");

  //: Clear all data on logout
  Future<void> clearAll() async => await storage.deleteAll();
}
