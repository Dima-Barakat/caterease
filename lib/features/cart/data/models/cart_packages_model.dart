import 'package:caterease/features/cart/domain/entities/cart_packages.dart';

class CartPackagesModel extends CartPackages {
  const CartPackagesModel({
    required bool status,
    required String message,
    required List<CartPackageItemModel> data,
  }) : super(
          status: status,
          message: message,
          data: data,
        );

  factory CartPackagesModel.fromJson(Map<String, dynamic> json) {
    return CartPackagesModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: (json["packages"] as List<dynamic>?)
              ?.map((e) => CartPackageItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CartPackageItemModel extends CartPackageItem {
  const CartPackageItemModel({
    required int cartItemId,
    required String packageId,
    required String packageName,
    required String packageDescription,
    required int servesCount,
    required String basePrice,
    required String packageImage,
    required int occasionTypeId,
    required String occasionTypeName,
    int? extraPersons,
    List<CartServiceTypeModel>? serviceTypes,
    List<CartExtraModel>? extras,
    required quantity,
  }) : super(
          cartItemId: cartItemId,
          packageId: packageId,
          packageName: packageName,
          packageDescription: packageDescription,
          servesCount: servesCount,
          basePrice: basePrice,
          packageImage: packageImage,
          occasionTypeId: occasionTypeId,
          occasionTypeName: occasionTypeName,
          extraPersons: extraPersons,
          serviceTypes: serviceTypes,
          extras: extras,
        );

  factory CartPackageItemModel.fromJson(Map<String, dynamic> json) {
    return CartPackageItemModel(
      cartItemId: json["cart_item_id"] ?? 0,
      packageId: json["package_id"]?.toString() ??
          json["cart_item_id"]?.toString() ??
          "", // Use cart_item_id if package_id is null or empty
      packageName: json["name"] ?? "",
      packageDescription: json["description"] ?? "",
      servesCount: json["serves_count"] ?? 0,
      basePrice: json["base_price"]?.toString() ?? "",
      packageImage: json["photo"] ?? "",
      occasionTypeId: json["occasion_type_id"] ?? 0,
      occasionTypeName: json["occasion_type_name"] ?? "",
      extraPersons: json["extra_persons"],
      serviceTypes: (json["service_type"] as List<dynamic>?)
          ?.map((e) => CartServiceTypeModel.fromJson(e))
          .toList(),
      extras: (json["extras"] as List<dynamic>?)
          ?.map((e) => CartExtraModel.fromJson(e))
          .toList(),
      quantity: json["quantity"],
    );
  }
}

class CartServiceTypeModel extends CartServiceType {
  const CartServiceTypeModel({
    required int id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );

  factory CartServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return CartServiceTypeModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }
}

class CartExtraModel extends CartExtra {
  const CartExtraModel({
    required int id,
    required String name,
    required double price,
    required int quantity,
  }) : super(
          id: id,
          name: name,
          price: price,
          quantity: quantity,
        );

  factory CartExtraModel.fromJson(Map<String, dynamic> json) {
    return CartExtraModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      quantity: json["quantity"] ?? 0,
    );
  }
}
