import 'package:equatable/equatable.dart';

class AddToCartRequest extends Equatable {
  final String packageId;
  final int quantity;
  final int extraPersons;
  final int occasionTypeId;
  final List<ServiceType> serviceType;
  final List<Extra> extras;

  const AddToCartRequest({
    required this.packageId,
    required this.quantity,
    required this.extraPersons,
    required this.occasionTypeId,
    required this.serviceType,
    required this.extras,
  });

  @override
  List<Object?> get props => [
        packageId,
        quantity,
        extraPersons,
        occasionTypeId,
        serviceType,
        extras,
      ];
}

class ServiceType extends Equatable {
  final int id;

  const ServiceType({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  @override
  List<Object?> get props => [id];
}

class Extra extends Equatable {
  final int extraId;
  final int quantity;

  const Extra({
    required this.extraId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'extra_id': extraId,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [extraId, quantity];
}


