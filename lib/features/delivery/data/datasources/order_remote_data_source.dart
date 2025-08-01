import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/features/delivery/data/models/order_model.dart';

abstract class BaseOrderRemoteDataSource {
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel> getOrderDetails();
}

class OrderRemoteDataSource implements BaseOrderRemoteDataSource {
  final NetworkClient client;

  OrderRemoteDataSource({required this.client});

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final response = await client.get(ApiConstants.orders);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw Exception(response.body.toString());
    }
  }

  @override
  Future<OrderModel> getOrderDetails() async {
    final response = await client.get(ApiConstants.orderDetails);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return OrderModel.fromJson(data['data']);
    } else {
      throw Exception(response.body.toString());
    }
  }
}
