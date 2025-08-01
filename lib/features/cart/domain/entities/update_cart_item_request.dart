import 'package:equatable/equatable.dart';

class UpdateCartItemRequest extends Equatable {
  final int cartItemId;
  final int quantity;
  final int extraPersons;
  final int occasionTypeId;
  final List<UpdateServiceType> serviceType;
  final List<UpdateExtra> extras;

  const UpdateCartItemRequest({
    required this.cartItemId,
    required this.quantity,
    required this.extraPersons,
    required this.occasionTypeId,
    required this.serviceType,
    required this.extras,
  });

  @override
  List<Object?> get props => [
        cartItemId,
        quantity,
        extraPersons,
        occasionTypeId,
        serviceType,
        extras,
      ];
}

class UpdateServiceType extends Equatable {
  final int id;

  const UpdateServiceType({
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

class UpdateExtra extends Equatable {
  final int extraId;
  final int quantity;

  const UpdateExtra({
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

