import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/features/delivery/data/models/order_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseOrderRemoteDataSource {
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel> getOrderDetails(int id);
  Future<Unit> changeOrderStatus(int id);
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
      throw ServerException(
          "Error while get All orders: ${response.body.toString()}");
    }
  }

  @override
  Future<OrderModel> getOrderDetails(int id) async {
    final response = await client.get("${ApiConstants.orderDetails}$id");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return OrderModel.fromJson(data['data']);
    } else {
      throw ServerException(
          "Error while get order details: ${response.body.toString()}");
    }
  }

  @override
  Future<Unit> changeOrderStatus(int id) async {
    final response = await client.post("${ApiConstants.orderStatus}$id");

    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerException(
          "Error while changing the order status: ${response.body.toString()}");
    }
  }
}
