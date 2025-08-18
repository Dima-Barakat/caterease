import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/features/delivery/data/models/delivery_profile_model.dart';

abstract class BaseDeliveryProfileRemoteDataSource {
  Future<DeliveryProfileModel> getProfile();
}

class DeliveryProfileRemoteDataSource
    extends BaseDeliveryProfileRemoteDataSource {
  final NetworkClient client;

  DeliveryProfileRemoteDataSource(this.client);

  @override
  Future<DeliveryProfileModel> getProfile() async {
    final response = await client.get(ApiConstants.deliveryProfile);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final result = DeliveryProfileModel.fromJson(responseData['data']);
      return result;
    } else {
      throw ServerException(
          "Error while getting profile: ${response.body.toString()}");
    }
  }
}

