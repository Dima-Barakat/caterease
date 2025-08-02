import 'package:caterease/features/cart/domain/entities/add_to_cart_request.dart';

class AddToCartRequestModel extends AddToCartRequest {
  const AddToCartRequestModel({
    required String packageId,
    required int quantity,
    required int extraPersons,
    required int occasionTypeId,
    required List<ServiceTypeModel> serviceType,
    required List<ExtraModel> extras,
  }) : super(
          packageId: packageId,
          quantity: quantity,
          extraPersons: extraPersons,
          occasionTypeId: occasionTypeId,
          serviceType: serviceType,
          extras: extras,
        );

  factory AddToCartRequestModel.fromJson(Map<String, dynamic> json) {
    return AddToCartRequestModel(
      packageId: json['package_id'],
      quantity: json['quantity'],
      extraPersons: json['extra_persons'],
      occasionTypeId: json['occasion_type_id'],
      serviceType: (json['service_type'] as List)
          .map((e) => ServiceTypeModel.fromJson(e))
          .toList(),
      extras:
          (json['extras'] as List).map((e) => ExtraModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package_id': packageId,
      'quantity': quantity,
      'extra_persons': extraPersons,
      'occasion_type_id': occasionTypeId,
      'service_type': serviceType.map((e) => e.toJson()).toList(),
      'extras': extras.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceTypeModel extends ServiceType {
  const ServiceTypeModel({
    required int id,
  }) : super(id: id);

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class ExtraModel extends Extra {
  const ExtraModel({
    required int extraId,
    required int quantity,
  }) : super(extraId: extraId, quantity: quantity);

  factory ExtraModel.fromJson(Map<String, dynamic> json) {
    return ExtraModel(
      extraId: json['extra_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extra_id': extraId,
      'quantity': quantity,
    };
  }
}
