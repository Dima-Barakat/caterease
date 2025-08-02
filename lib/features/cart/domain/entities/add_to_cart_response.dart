import 'package:equatable/equatable.dart';

class AddToCartResponse extends Equatable {
  final bool status;
  final String message;
  final CartData data;

  const AddToCartResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

class CartData extends Equatable {
  final int cartItemId;
  final double totalPrice;
  final String cartTotal;
  final Details details;

  const CartData({
    required this.cartItemId,
    required this.totalPrice,
    required this.cartTotal,
    required this.details,
  });

  @override
  List<Object?> get props => [cartItemId, totalPrice, cartTotal, details];
}

class Details extends Equatable {
  final String package;
  final String originalPrice;
  final String discountPercentage;
  final String discountedPrice;
  final String quantity;
  final String extraPersons;
  final String extraPersonsCost;
  final List<ExtraItem> extras;
  final List<ServiceTypeItem> serviceType;
  final String serviceTypeCost;
  final String occasionTypeId;
  final String occasionTypeName;
  final String total;

  const Details({
    required this.package,
    required this.originalPrice,
    required this.discountPercentage,
    required this.discountedPrice,
    required this.quantity,
    required this.extraPersons,
    required this.extraPersonsCost,
    required this.extras,
    required this.serviceType,
    required this.serviceTypeCost,
    required this.occasionTypeId,
    required this.occasionTypeName,
    required this.total,
  });

  @override
  List<Object?> get props => [
        package,
        originalPrice,
        discountPercentage,
        discountedPrice,
        quantity,
        extraPersons,
        extraPersonsCost,
        extras,
        serviceType,
        serviceTypeCost,
        occasionTypeId,
        occasionTypeName,
        total,
      ];
}

class ExtraItem extends Equatable {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final double total;

  const ExtraItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object?> get props => [id, name, price, quantity, total];
}

class ServiceTypeItem extends Equatable {
  final int id;
  final String name;
  final int price;

  const ServiceTypeItem({
    required this.id,
    required this.name,
    required this.price,
  });
  @override
  List<Object?> get props => [id, name, price];
}
