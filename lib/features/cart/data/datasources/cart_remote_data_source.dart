import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/features/cart/data/models/add_to_cart_request_model.dart';
import 'package:caterease/features/cart/data/models/add_to_cart_response_model.dart';
import 'package:caterease/features/cart/data/models/cart_packages_model.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_request.dart';
import 'package:caterease/features/cart/data/models/updated_cart_data_model.dart';
import 'package:caterease/features/cart/domain/entities/remove_cart_item_response.dart';

import 'dart:convert';
import 'package:caterease/core/constants/api_constants.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_response.dart';

abstract class CartRemoteDataSource {
  Future<AddToCartResponseModel> addToCart(AddToCartRequestModel request);
  Future<CartPackagesModel> getCartPackages();
  Future<UpdateCartItemResponse> updateCartItem(
      int cartItemId, UpdateCartItemRequest request);
  Future<RemoveCartItemResponse> removeCartItem(int cartItemId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final NetworkClient client;

  CartRemoteDataSourceImpl({required this.client});

  @override
  Future<AddToCartResponseModel> addToCart(
      AddToCartRequestModel request) async {
    final url = ApiConstants.baseUrl + ApiConstants.addToCart;
    print('Cart API Request URL: $url');
    print('Cart API Request Body: ${request.toJson()}');

    final response = await client.post(
      url,
      body: request.toJson(),
    );

    print('Cart API Response Status Code: ${response.statusCode}');
    print('Cart API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return AddToCartResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CartPackagesModel> getCartPackages() async {
    final url = ApiConstants.baseUrl + ApiConstants.getCartPackages;
    print('Get Cart Packages API Request URL: $url');

    final response = await client.get(url);

    print('Get Cart Packages API Response Status Code: ${response.statusCode}');
    print('Get Cart Packages API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return CartPackagesModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UpdateCartItemResponse> updateCartItem(
      int cartItemId, UpdateCartItemRequest request) async {
    final url = ApiConstants.baseUrl +
        ApiConstants.updateCartItem +
        cartItemId.toString();
    print('Update Cart Item API Request URL: $url');

    // Convert request to map for API
    final requestBody = {
      'extra_persons': request.extraPersons,
      'occasion_type_id': request.occasionTypeId,
    };

    // Add service types
    for (int i = 0; i < request.serviceType.length; i++) {
      requestBody['service_type[$i][id]'] = request.serviceType[i].id;
    }

    // Add extras
    for (int i = 0; i < request.extras.length; i++) {
      requestBody['extras[$i][extra_id]'] = request.extras[i].extraId;
      requestBody['extras[$i][quantity]'] = request.extras[i].quantity;
    }

    print('Update Cart Item API Request Body: $requestBody');

    final response = await client.post(url, body: requestBody);

    print('Update Cart Item API Response Status Code: ${response.statusCode}');
    print('Update Cart Item API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return UpdateCartItemResponse(
        message: responseData["message"] ?? "تم تحديث العنصر بنجاح",
        status: responseData["status"],
        data: UpdatedCartDataModel.fromJson(responseData["data"] ?? {}),
      );
    } else {
      throw ServerException();
    }
  }

  @override
  Future<RemoveCartItemResponse> removeCartItem(int cartItemId) async {
    final url = ApiConstants.baseUrl +
        ApiConstants.removeCartItem +
        cartItemId.toString();
    print('Remove Cart Item API Request URL: $url');

    final response = await client.delete(url);

    print('Remove Cart Item API Response Status Code: ${response.statusCode}');
    print('Remove Cart Item API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return RemoveCartItemResponse(
        message: responseData['message'] ?? 'تم حذف العنصر بنجاح',
        status: responseData['status'],
      );
    } else {
      throw ServerException();
    }
  }
}
