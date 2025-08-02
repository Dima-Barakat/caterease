import 'package:caterease/features/cart/domain/entities/add_to_cart_response.dart';

class AddToCartResponseModel extends AddToCartResponse {
  const AddToCartResponseModel({
    required bool status,
    required String message,
    required CartDataModel data,
  }) : super(
          status: status,
          message: message,
          data: data,
        );

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) {
    return AddToCartResponseModel(
      status: json['status'],
      message: json['message'],
      data: CartDataModel.fromJson(json['data']),
    );
  }
}

class CartDataModel extends CartData {
  const CartDataModel({
    required int cartItemId,
    required double totalPrice,
    required String cartTotal,
    required DetailsModel details,
  }) : super(
          cartItemId: cartItemId,
          totalPrice: totalPrice,
          cartTotal: cartTotal,
          details: details,
        );

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    return CartDataModel(
      cartItemId: json['cart_item_id'],
      totalPrice: json['total_price'].toDouble(),
      cartTotal: json['cart_total'],
      details: DetailsModel.fromJson(json['details']),
    );
  }
}

class DetailsModel extends Details {
  const DetailsModel({
    required String package,
    required String originalPrice,
    required String discountPercentage,
    required String discountedPrice,
    required String quantity,
    required String extraPersons,
    required String extraPersonsCost,
    required List<ExtraItemModel> extras,
    required List<ServiceTypeItemModel> serviceType,
    required String serviceTypeCost,
    required String occasionTypeId,
    required String occasionTypeName,
    required String total,
  }) : super(
          package: package,
          originalPrice: originalPrice,
          discountPercentage: discountPercentage,
          discountedPrice: discountedPrice,
          quantity: quantity,
          extraPersons: extraPersons,
          extraPersonsCost: extraPersonsCost,
          extras: extras,
          serviceType: serviceType,
          serviceTypeCost: serviceTypeCost,
          occasionTypeId: occasionTypeId,
          occasionTypeName: occasionTypeName,
          total: total,
        );
  factory DetailsModel.fromJson(Map<String, dynamic> json) {
    return DetailsModel(
      package: json['package'] as String,
      originalPrice: json['original_price'] as String,
      discountPercentage: json['discount_percentage']?.toString() ?? '',
      discountedPrice: json['discounted_price']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '0',
      extraPersons: json['extra_persons']?.toString() ?? '0',
      extraPersonsCost: json['extra_persons_cost']?.toString() ?? '0',
      extras: (json['extras'] as List<dynamic>?)
              ?.map((e) => ExtraItemModel.fromJson(e))
              .toList() ??
          [],
      serviceType: (json['service_type'] as List<dynamic>?)
              ?.map((e) => ServiceTypeItemModel.fromJson(e))
              .toList() ??
          [],
      serviceTypeCost: json['service_type_cost']?.toString() ?? '0',
      occasionTypeId: json['occasion_type_id']?.toString() ?? '0',
      occasionTypeName: json['occasion_type_name'] as String? ?? '',
      total: json['total'] as String? ?? '0',
    );
  }
}

class ExtraItemModel extends ExtraItem {
  const ExtraItemModel({
    required int id,
    required String name,
    required double price,
    required int quantity,
    required double total,
  }) : super(
          id: id,
          name: name,
          price: price,
          quantity: quantity,
          total: total,
        );

  factory ExtraItemModel.fromJson(Map<String, dynamic> json) {
    return ExtraItemModel(
      id: json["id"],
      name: json["name"],
      price: json["price"].toDouble(),
      quantity: json["quantity"], // الآن يتوقع int
      total: json["total"].toDouble(),
    );
  }
}

class ServiceTypeItemModel extends ServiceTypeItem {
  const ServiceTypeItemModel({
    required int id,
    required String name,
    required int price,
  }) : super(
          id: id,
          name: name,
          price: price,
        );

  factory ServiceTypeItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeItemModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}
