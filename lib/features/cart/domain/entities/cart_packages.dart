import 'package:equatable/equatable.dart';

class CartPackages extends Equatable {
  final bool status;
  final String message;
  final List<CartPackageItem> data;

  const CartPackages({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

class CartPackageItem extends Equatable {
  final int cartItemId;
  final String packageId;
  final String packageName;
  final String packageDescription;
  final int? servesCount;
  final String packageImage;
  final String? basePrice;
  final int occasionTypeId;
  final String occasionTypeName;
  final int? extraPersons;
  final List<CartServiceType>? serviceTypes;
  final List<CartExtra>? extras;
  final int? quantity;

  const CartPackageItem({
    required this.cartItemId,
    required this.packageId,
    required this.packageName,
    required this.packageDescription,
    required this.servesCount,
    required this.packageImage,
    required this.basePrice,
    required this.occasionTypeId,
    required this.occasionTypeName,
    this.extraPersons,
    this.serviceTypes,
    this.extras,
    this.quantity,
  });

  @override
  List<Object?> get props => [
        cartItemId,
        packageId,
        packageName,
        packageDescription,
        servesCount,
        packageImage,
        basePrice,
        occasionTypeId,
        occasionTypeName,
        extraPersons,
        serviceTypes,
        extras,
        quantity,
      ];
}

class CartServiceType extends Equatable {
  final int id;
  final String name;

  const CartServiceType({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class CartExtra extends Equatable {
  final int id;
  final String name;
  final double price;
  final int quantity;

  const CartExtra({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, name, price, quantity];
}