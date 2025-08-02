import 'package:caterease/features/packages/domain/entities/discount.dart';
import 'package:caterease/features/packages/domain/entities/package_detail.dart';
import 'discount_model.dart';

class PackageDetailModel extends PackageDetail {
  const PackageDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.servesCount,
    required super.photo,
    super.basePrice,
    required super.prepaymentRequired,
    super.prepaymentAmount,
    required super.branchId,
    required super.branchName,
    required super.serviceType,
    required super.occasionTypes,
    required super.categories,
    required super.maxExtraPersons,
    super.pricePerExtraPerson,
    required super.items,
    required super.extras,
    super.discount,
    super.finalPrice,
  });

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      return PackageDetailModel(
        id: _parseToInt(json['id']),
        name: _parseToString(json['name']),
        description: _parseToString(json['description']),
        servesCount: _parseToInt(json['serves_count']),
        photo: _parseToString(json['photo']),
        basePrice: _parseToDouble(json['base_price']),
        prepaymentRequired: _parseToBool(json['prepayment_required']),
        prepaymentAmount: _parseToDouble(json['prepayment_amount']),
        branchId: _parseToInt(json['branch_id']),
        branchName: _parseToString(json['branch_name']),
        serviceType: _parseServiceType(json['service_type']),
        occasionTypes: _parseOccasionTypes(json['occasion_types']),
        categories: _parseCategories(json['categories']),
        maxExtraPersons: _parseToInt(json['max_extra_persons']),
        pricePerExtraPerson: _parseToDouble(json['price_per_extra_person']),
        items: _parsePackageItems(json["items"]),
        extras: _parsePackageExtras(json["extras"]),
        discount: json["discount"] != null
            ? DiscountModel.fromJson(json["discount"])
            : null,
        finalPrice: _parseToDouble(json["final_price"]),
      );
    } catch (e) {
      throw FormatException('Error parsing PackageDetailModel: $e');
    }
  }

  // Helper methods for safe parsing
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double? _parseToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String _parseToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static bool _parseToBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  static List<ServiceType> _parseServiceType(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];

    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => ServiceTypeModel.fromJson(item))
        .toList();
  }

  static List<OccasionType> _parseOccasionTypes(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];

    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => OccasionTypeModel.fromJson(item))
        .toList();
  }

  static List<String> _parseCategories(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return [];
  }

  static List<PackageItem> _parsePackageItems(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];

    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => PackageItemModel.fromJson(item))
        .toList();
  }

  static List<PackageExtra> _parsePackageExtras(dynamic value) {
    if (value == null) return [];
    if (value is! List) return [];

    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => PackageExtraModel.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'serves_count': servesCount,
      'photo': photo,
      'base_price': basePrice?.toString(),
      'prepayment_required': prepaymentRequired ? 1 : 0,
      'prepayment_amount': prepaymentAmount?.toString(),
      'branch_id': branchId,
      'branch_name': branchName,
      'service_type':
          serviceType.map((e) => (e as ServiceTypeModel).toJson()).toList(),
      'occasion_types':
          occasionTypes.map((e) => (e as OccasionTypeModel).toJson()).toList(),
      'categories': categories,
      'max_extra_persons': maxExtraPersons,
      'price_per_extra_person': pricePerExtraPerson?.toString(),
      'items': items.map((e) => (e as PackageItemModel).toJson()).toList(),
      'extras': extras.map((e) => (e as PackageExtraModel).toJson()).toList(),
      'discount': (discount as DiscountModel?)?.toJson(),
      'final_price': finalPrice?.toString(),
    };
  }
}

class ServiceTypeModel extends ServiceType {
  const ServiceTypeModel({
    required super.id,
    required super.name,
    required super.serviceCost,
  });

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      id: PackageDetailModel._parseToInt(json['id']),
      name: PackageDetailModel._parseToString(json['name']),
      serviceCost: PackageDetailModel._parseToDouble(json["custom_price"]) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'service_cost': serviceCost.toString(),
    };
  }
}

class OccasionTypeModel extends OccasionType {
  const OccasionTypeModel({
    required super.id,
    required super.name,
  });

  factory OccasionTypeModel.fromJson(Map<String, dynamic> json) {
    return OccasionTypeModel(
      id: PackageDetailModel._parseToInt(json['id']),
      name: PackageDetailModel._parseToString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class PackageItemModel extends PackageItem {
  const PackageItemModel({
    required super.foodItemId,
    required super.foodItemName,
    required super.quantity,
    required super.isOptional,
  });

  factory PackageItemModel.fromJson(Map<String, dynamic> json) {
    return PackageItemModel(
      foodItemId: PackageDetailModel._parseToInt(json['food_item_id']),
      foodItemName: PackageDetailModel._parseToString(json['food_item_name']),
      quantity: PackageDetailModel._parseToInt(json['quantity']),
      isOptional: PackageDetailModel._parseToBool(json['is_optional']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_item_id': foodItemId,
      'food_item_name': foodItemName,
      'quantity': quantity,
      'is_optional': isOptional ? 1 : 0,
    };
  }
}

class PackageExtraModel extends PackageExtra {
  const PackageExtraModel({
    required super.id,
    required super.type,
    required super.name,
    required super.price,
    required super.isOptional,
  });

  factory PackageExtraModel.fromJson(Map<String, dynamic> json) {
    return PackageExtraModel(
      id: PackageDetailModel._parseToInt(json['id']),
      type: PackageDetailModel._parseToString(json['type']),
      name: PackageDetailModel._parseToString(json['name']),
      price: PackageDetailModel._parseToDouble(json["price"]) ?? 0.0,
      isOptional: PackageDetailModel._parseToBool(json['is_optional']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'price': price.toString(),
      'is_optional': isOptional ? 1 : 0,
    };
  }
}
