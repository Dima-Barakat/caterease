import 'dart:convert';

import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/features/profile/data/models/address_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseAddressRemoteDatasource {
  Future<List<AddressModel>> getAllAddresses();

  Future<Unit> createAddress(String cityId, String? street, String? building,
      String? floor, String? apartment, String? long, String? lat);

  Future<Unit> deleteAddress(int id);
}

class AddressRemoteDatasource extends BaseAddressRemoteDatasource {
  final NetworkClient client;

  AddressRemoteDatasource({required this.client});

  @override
  Future<List<AddressModel>> getAllAddresses() async {
    final response = await client.get(ApiConstants.getAllAddress);
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> restaurants = responseData["data"];
      return restaurants.map((json) => AddressModel.fromJson(json)).toList();
    } else {
      throw Exception(response.body.toString());
    }
  }

  @override
  Future<Unit> createAddress(String cityId, String? street, String? building,
      String? floor, String? apartment, String? long, String? lat) async {
    final body = {
      "city_id": cityId,
      if (street != null) "street": street,
      if (building != null) "building": building,
      if (floor != null) "floor": floor,
      if (apartment != null) "apartment": apartment,
      if (long != null) "longitude": long,
      if (lat != null) "latitude": lat,
    };
    await client.post(ApiConstants.createAddress, body: body);
    return unit;
  }

  @override
  Future<Unit> deleteAddress(int id) async {
    await client.delete("${ApiConstants.deleteAddress}$id");
    return unit;
  }
}
