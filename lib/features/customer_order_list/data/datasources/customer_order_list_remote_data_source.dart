import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/data/models/bill_model.dart';
import 'package:caterease/features/customer_order_list/data/models/customer_order_list_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:caterease/core/storage/secure_storage.dart';

abstract class CustomerOrderListRemoteDataSource {
  Future<List<CustomerOrderListModel>> getCustomerOrderList();
  Future<bool> deleteOrder(int orderId);
  Future<String> paymentCode(double amount);
  Future<void> paymentBill(
      String billId, String paymentType, String paymentMethod, double amount);
  Future<BillModel> getBill(String id);
  Future<Unit> applyCoupon(String id, String coupon);
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
      Uri.parse('${ApiConstants.baseUrl}/order/$orderId'),
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

  @override
  Future<String> paymentCode(double amount) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();
    final response =
        await client.post(Uri.parse(ApiConstants.clientSecret), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'amount': amount.toString()
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        print(jsonResponse['client_secret']);
        return jsonResponse['client_secret'];
      } else {
        print("Error in Payment Code: ${response.body}");
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> paymentBill(String billId, String paymentType,
      String paymentMethod, double amount) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();
    final response = await client.post(
        Uri.parse(ApiConstants.pay.replaceFirst('{id}', billId)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'payment_type': paymentType,
          'payment_method': paymentMethod,
          'amount': amount.toString()
        });
    print(response.body.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return {};
    } else {
      throw ServerException();
    }
  }

  @override
  Future<BillModel> getBill(String id) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/bill/orders/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        return BillModel.fromJson(jsonResponse['data']);
      } else {
        debugPrint('Failure in get Bill: ${jsonResponse['message']}');
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> applyCoupon(String id, String coupon) async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();
    final response = await client.post(
        Uri.parse(ApiConstants.applyCoupon.replaceFirst('{billId}', id)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'coupon_code': coupon
        });
    debugPrint(response.body);
    if (response.statusCode == 200) {
      return unit;
    } else {
      debugPrint('Failure in get Bill: ${response.body}');
      throw ServerException();
    }
  }
}
