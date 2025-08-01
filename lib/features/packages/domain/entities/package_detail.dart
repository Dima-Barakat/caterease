import 'package:caterease/features/packages/domain/entities/discount.dart';
import 'package:equatable/equatable.dart';

class PackageDetail extends Equatable {
  final int id;
  final String name;
  final String description;
  final int servesCount;
  final String photo;
  final double? basePrice;
  final bool prepaymentRequired;
  final double? prepaymentAmount;
  final int branchId;
  final String branchName;
  final List<ServiceType> serviceType;
  final List<OccasionType> occasionTypes;
  final List<String> categories;
  final int maxExtraPersons;
  final double? pricePerExtraPerson;
  final List<PackageItem> items;
  final List<PackageExtra> extras;
  final Discount? discount;
  final double? finalPrice;

  const PackageDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.servesCount,
    required this.photo,
    this.basePrice,
    required this.prepaymentRequired,
    this.prepaymentAmount,
    required this.branchId,
    required this.branchName,
    required this.serviceType,
    required this.occasionTypes,
    required this.categories,
    required this.maxExtraPersons,
    this.pricePerExtraPerson,
    required this.items,
    required this.extras,
    this.discount,
    this.finalPrice,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        servesCount,
        photo,
        basePrice,
        prepaymentRequired,
        prepaymentAmount,
        branchId,
        branchName,
        serviceType,
        occasionTypes,
        categories,
        maxExtraPersons,
        pricePerExtraPerson,
        items,
        extras,
        discount,
        finalPrice,
      ];
}

class ServiceType extends Equatable {
  final int id;
  final String name;
  final double? serviceCost;

  const ServiceType({
    required this.id,
    required this.name,
    this.serviceCost,
  });

  @override
  List<Object?> get props => [id, name, serviceCost];
}

class OccasionType extends Equatable {
  final int id;
  final String name;

  const OccasionType({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class PackageItem extends Equatable {
  final int foodItemId;
  final String foodItemName;
  final int quantity;
  final bool isOptional;

  const PackageItem({
    required this.foodItemId,
    required this.foodItemName,
    required this.quantity,
    required this.isOptional,
  });

  @override
  List<Object?> get props => [foodItemId, foodItemName, quantity, isOptional];
}

class PackageExtra extends Equatable {
  final int id;
  final String type;
  final String name;
  final double? price;
  final bool isOptional;

  const PackageExtra({
    required this.id,
    required this.type,
    required this.name,
    this.price,
    required this.isOptional,
  });

  @override
  List<Object?> get props => [id, type, name, price, isOptional];
}
