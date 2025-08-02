import 'dart:convert';
import 'package:caterease/core/error/failures.dart';
import 'package:http/http.dart' as http;
import '../models/package_model.dart';
import '../models/package_detail_model.dart';
import 'package:caterease/core/storage/secure_storage.dart';

abstract class PackagesRemoteDataSource {
  Future<List<PackageModel>> getPackagesForBranch(int branchId);
  Future<PackageDetailModel> getPackageDetail(int packageId);
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

  @override
  Future<PackageDetailModel> getPackageDetail(int packageId) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();

    final response = await client.get(
      Uri.parse('http://192.168.198.155:8000/api/packages/$packageId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // التحقق من نوع البيانات المستلمة
      if (jsonResponse is Map<String, dynamic>) {
        // إذا كانت البيانات من نوع Map، نتحقق من وجود 'data'
        if (jsonResponse.containsKey('data')) {
          final dynamic packageData = jsonResponse['data'];
          if (packageData is Map<String, dynamic>) {
            return PackageDetailModel.fromJson(packageData);
          } else {
            throw ServerException();
          }
        } else {
          // إذا لم توجد 'data'، نستخدم البيانات مباشرة
          return PackageDetailModel.fromJson(jsonResponse);
        }
      } else if (jsonResponse is List) {
        // إذا كانت البيانات من نوع List، نأخذ العنصر الأول
        if (jsonResponse.isNotEmpty &&
            jsonResponse[0] is Map<String, dynamic>) {
          return PackageDetailModel.fromJson(jsonResponse[0]);
        } else {
          throw ServerException();
        }
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}
