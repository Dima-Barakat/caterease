import 'dart:convert';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/order_details_feature/data/datasources/order_details_remote_data_source.dart';
import 'package:caterease/features/order_details_feature/data/models/order_details_model.dart';
import 'package:http/http.dart' as http;

class OrderDetailsRemoteDataSourceImpl implements OrderDetailsRemoteDataSource {
  final http.Client client;

  OrderDetailsRemoteDataSourceImpl({required this.client});

  @override
  Future<OrderDetailsModel> getOrderDetails(int orderId) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();
    final response = await client.get(
      Uri.parse('http://192.168.67.155:8000/api/order/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return OrderDetailsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
