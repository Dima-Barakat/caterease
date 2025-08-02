import 'package:caterease/features/cart/domain/entities/update_cart_item_response.dart';

class UpdatedCartDataModel extends UpdatedCartData {
  const UpdatedCartDataModel({
    required int cartItemId,
    required double totalPrice,
    required String cartTotal,
    required UpdatedDetailsModel details,
  }) : super(
          cartItemId: cartItemId,
          totalPrice: totalPrice,
          cartTotal: cartTotal,
          details: details,
        );

  factory UpdatedCartDataModel.fromJson(Map<String, dynamic> json) {
    return UpdatedCartDataModel(
      cartItemId: json['cart_item_id'] ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      cartTotal: json['cart_total']?.toString() ?? '',
      details: UpdatedDetailsModel.fromJson(json['details'] ?? {}),
    );
  }
}

class UpdatedDetailsModel extends UpdatedDetails {
  const UpdatedDetailsModel({
    required String package,
    required String originalPrice,
    required String discountPercentage,
    required String discountedPrice,
    required int quantity,
    required String extraPersons,
    required String extraPersonsCost,
    required List<UpdatedExtraItemModel> extras,
    required List<UpdatedServiceTypeItemModel> serviceType,
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

  factory UpdatedDetailsModel.fromJson(Map<String, dynamic> json) {
    return UpdatedDetailsModel(
      package: json['package']?.toString() ?? '',
      originalPrice: json['original_price']?.toString() ?? '',
      discountPercentage: json['discount_percentage']?.toString() ?? '',
      discountedPrice: json['discounted_price']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      extraPersons: json['extra_persons']?.toString() ?? '',
      extraPersonsCost: json['extra_persons_cost']?.toString() ?? '',
      extras: (json['extras'] as List<dynamic>?)
              ?.map((e) => UpdatedExtraItemModel.fromJson(e))
              .toList() ??
          [],
      serviceType: (json['service_type'] as List<dynamic>?)
              ?.map((e) => UpdatedServiceTypeItemModel.fromJson(e))
              .toList() ??
          [],
      serviceTypeCost: json['service_type_cost']?.toString() ?? '',
      occasionTypeId: json['occasion_type_id']?.toString() ?? '',
      occasionTypeName: json['occasion_type_name']?.toString() ?? '',
      total: json['total']?.toString() ?? '',
    );
  }
}

class UpdatedExtraItemModel extends UpdatedExtraItem {
  const UpdatedExtraItemModel({
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

  factory UpdatedExtraItemModel.fromJson(Map<String, dynamic> json) {
    return UpdatedExtraItemModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class UpdatedServiceTypeItemModel extends UpdatedServiceTypeItem {
  const UpdatedServiceTypeItemModel({
    required int id,
    required String name,
    required int price,
  }) : super(
          id: id,
          name: name,
          price: price,
        );

  factory UpdatedServiceTypeItemModel.fromJson(Map<String, dynamic> json) {
    return UpdatedServiceTypeItemModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      price: json['price'] ?? 0,
    );
  }
}

