import 'package:caterease/features/order_details_feature/domain/entities/order_details_entity.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  OrderDetailsModel({
    required int orderId,
    required String status,
    required bool isApproved,
    String? approvalDeadline,
    String? notes,
    required String deliveryTime,
    required String totalPrice,
    required AddressModel address,
    required List<PackageModel> packages,
    BillModel? bill,
  }) : super(
          orderId: orderId,
          status: status,
          isApproved: isApproved,
          approvalDeadline: approvalDeadline,
          notes: notes,
          deliveryTime: deliveryTime,
          totalPrice: totalPrice,
          address: address,
          packages: packages,
          bill: bill,
        );

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};
    return OrderDetailsModel(
      orderId: data["order_id"] ?? 0,
      status: data["status"] ?? '',
      isApproved: data["is_approved"] ?? false,
      approvalDeadline: data["approval_deadline"] ?? '',
      notes: data["notes"] ?? '',
      deliveryTime: data["delivery_time"] ?? '',
      totalPrice: data["total_price"] ?? '0',
      address: AddressModel.fromJson(data["address"] ?? {}),
      packages: (data["packages"] as List? ?? [])
          .map((e) => PackageModel.fromJson(e))
          .toList(),
      bill: data["bill"] != null ? BillModel.fromJson(data["bill"]) : null,
    );
  }
}

class AddressModel extends AddressEntity {
  AddressModel({
    required String street,
    required String building,
    required String floor,
    required String apartment,
    required String city,
  }) : super(
          street: street,
          building: building,
          floor: floor,
          apartment: apartment,
          city: city,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json["street"] ?? '',
      building: json["building"] ?? '',
      floor: json["floor"] ?? '',
      apartment: json["apartment"] ?? '',
      city: json["city"] ?? '',
    );
  }
}

class PackageModel extends PackageEntity {
  PackageModel({
    required int orderDetailsId,
    required int packageId,
    required String name,
    required int branchId,
    required String restaurantName,
    required String description,
    required String photo,
    required String basePrice,
    required int quantity,
    required int servesCount,
    required int extraPersons,
    required String pricePerExtraPerson,
    required String extraPersonsCost,
    required int totalPersons,
    required bool prepaymentRequired,
    required String prepaymentPercentage,
    required String prepaymentAmount,
    required String cancellationPolicy,
    required String occasionType,
    required List<ItemModel> items,
    required List<ServiceModel> services,
    required List<ExtraModel> extras,
    required String finalTotal,
  }) : super(
          orderDetailsId: orderDetailsId,
          packageId: packageId,
          name: name,
          branchId: branchId,
          restaurantName: restaurantName,
          description: description,
          photo: photo,
          basePrice: basePrice,
          quantity: quantity,
          servesCount: servesCount,
          extraPersons: extraPersons,
          pricePerExtraPerson: pricePerExtraPerson,
          extraPersonsCost: extraPersonsCost,
          totalPersons: totalPersons,
          prepaymentRequired: prepaymentRequired,
          prepaymentPercentage: prepaymentPercentage,
          prepaymentAmount: prepaymentAmount,
          cancellationPolicy: cancellationPolicy,
          occasionType: occasionType,
          items: items,
          services: services,
          extras: extras,
          finalTotal: finalTotal,
        );

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      orderDetailsId: json["order_details_id"] ?? 0,
      packageId: json["package_id"] ?? 0,
      name: json["name"] ?? '',
      branchId: json["branch_id"] ?? 0,
      restaurantName: json["restaurant_name"] ?? '',
      description: json["description"] ?? '',
      photo: json["photo"] ?? '',
      basePrice: json["base_price"] ?? '0',
      quantity: json["quantity"] ?? 0,
      servesCount: json["serves_count"] ?? 0,
      extraPersons: json["extra_persons"] ?? 0,
      pricePerExtraPerson: json["price_per_extra_person"] ?? '0',
      extraPersonsCost: json["extra_persons_cost"] ?? '0',
      totalPersons: json["total_persons"] ?? 0,
      prepaymentRequired: json["prepayment_required"] ?? false,
      prepaymentPercentage: json["prepayment_percentage"] ?? '0',
      prepaymentAmount: json["prepayment_amount"] ?? '0',
      cancellationPolicy: json["cancellation_policy"] ?? '',
      occasionType: json["occasion_type"] ?? '',
      items: (json["items"] as List? ?? [])
          .map((e) => ItemModel.fromJson(e))
          .toList(),
      services: (json["services"] as List? ?? [])
          .map((e) => ServiceModel.fromJson(e))
          .toList(),
      extras: (json["extras"] as List? ?? [])
          .map((e) => ExtraModel.fromJson(e))
          .toList(),
      finalTotal: json["final_total"] ?? '0',
    );
  }
}

class ItemModel extends ItemEntity {
  ItemModel({
    required int foodItemId,
    required String foodItemName,
    required int quantity,
  }) : super(
          foodItemId: foodItemId,
          foodItemName: foodItemName,
          quantity: quantity,
        );

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      foodItemId: json["food_item_id"] ?? 0,
      foodItemName: json["food_item_name"] ?? '',
      quantity: json["quantity"] ?? 0,
    );
  }
}

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required String name,
    required String customPrice,
  }) : super(
          name: name,
          customPrice: customPrice,
        );

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      name: json["name"] ?? '',
      customPrice: json["custom_price"] ?? '0',
    );
  }
}

class ExtraModel extends ExtraEntity {
  ExtraModel();

  factory ExtraModel.fromJson(Map<String, dynamic> json) {
    return ExtraModel();
  }
}

class BillModel extends BillEntity {
  BillModel();

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel();
  }
}
