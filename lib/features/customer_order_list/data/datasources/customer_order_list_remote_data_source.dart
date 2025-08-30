import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/data/models/customer_order_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:caterease/core/storage/secure_storage.dart';

abstract class CustomerOrderListRemoteDataSource {
  Future<List<CustomerOrderListModel>> getCustomerOrderList();
  Future<bool> deleteOrder(int orderId);
}

class CustomerOrderListRemoteDataSourceImpl
    implements CustomerOrderListRemoteDataSource {
  final http.Client client;

  CustomerOrderListRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CustomerOrderListModel>> getCustomerOrderList() async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/order/user/orders'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        return (jsonResponse['data'] as List)
            .map((e) => CustomerOrderListModel.fromJson(e))
            .toList();
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteOrder(int orderId) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();
    final response = await client.delete(
      Uri.parse('http://10.184.209.155:8000/api/order/$orderId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        return true;
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}
