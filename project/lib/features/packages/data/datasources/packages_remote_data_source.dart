import 'dart:convert';
import 'package:caterease/core/error/failures.dart';
import 'package:http/http.dart' as http;
import '../models/package_model.dart';
import 'package:caterease/core/storage/secure_storage.dart';

abstract class PackagesRemoteDataSource {
  Future<List<PackageModel>> getPackagesForBranch(int branchId);
}

class PackagesRemoteDataSourceImpl implements PackagesRemoteDataSource {
  final http.Client client;

  PackagesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PackageModel>> getPackagesForBranch(int branchId) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();

    final response = await client.get(
      Uri.parse('http://192.168.198.155:8000/api/branches/$branchId/packages'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> packagesJson = jsonResponse['packages'];
      return packagesJson.map((json) => PackageModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}
