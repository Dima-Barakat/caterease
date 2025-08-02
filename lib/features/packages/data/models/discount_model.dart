import 'package:caterease/features/packages/domain/entities/discount.dart';

class DiscountModel extends Discount {
  const DiscountModel({
    required super.value,
    required super.description,
    required super.startAt,
    required super.endAt,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      value: json['value'] as String,
      description: json['description'] as String,
      startAt: json['start_at'] as String,
      endAt: json['end_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'description': description,
      'start_at': startAt,
      'end_at': endAt,
    };
  }
}


