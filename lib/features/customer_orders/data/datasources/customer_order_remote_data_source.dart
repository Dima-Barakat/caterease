import 'dart:convert';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/core/constants/api_constants.dart';
import 'package:intl/intl.dart';

abstract class CustomerOrderRemoteDataSource {
  Future<void> createCustomerOrder(Map<String, dynamic> customerOrderData);
}

class CustomerOrderRemoteDataSourceImpl
    implements CustomerOrderRemoteDataSource {
  final NetworkClient networkClient;

  CustomerOrderRemoteDataSourceImpl({required this.networkClient});

  @override
  Future<void> createCustomerOrder(
      Map<String, dynamic> customerOrderData) async {
    try {
      // Convert the customerOrder data to flat keys format for the API
      final Map<String, dynamic> flatData =
          _convertToFlatKeys(customerOrderData);

      print(">> Sending customer order data: $flatData");

      final response = await networkClient.post(
        'http://192.168.67.155:8000/api/order/create',
        body: flatData,
      );

      print(">> Response status: ${response.statusCode}");
      print(">> Response body: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      print('>> Error creating customer order: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  Map<String, dynamic> _convertToFlatKeys(
      Map<String, dynamic> customerOrderData) {
    final Map<String, dynamic> flatData = {};

    // Add basic fields
    flatData["notes"] = customerOrderData["notes"];

    // Format delivery_time
    final DateTime deliveryDateTime =
        DateTime.parse(customerOrderData["delivery_time"]);
    flatData["delivery_time"] =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(deliveryDateTime);

    // Add cart item IDs as a JSON array
    flatData["cart_item_ids"] = customerOrderData["cart_item_ids"];

    // Add address data as a JSON object
    flatData["address"] = customerOrderData["address"];

    return flatData;
  }
}
