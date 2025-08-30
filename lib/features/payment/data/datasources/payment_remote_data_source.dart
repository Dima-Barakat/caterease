import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/network/network_client.dart';

abstract class BasePaymentRemoteDataSource {
  Future<Map<String, String>> getClientSecret();
}

class PaymentRemoteDataSource implements BasePaymentRemoteDataSource {
  final NetworkClient client;

  PaymentRemoteDataSource(this.client);
  @override
  Future<Map<String, String>> getClientSecret() async {
    final response = await client.get(ApiConstants.clientSecret);
    final responseData = json.decode(response.body);
    return Map<String, String>.from(responseData['data']);
  }
}
