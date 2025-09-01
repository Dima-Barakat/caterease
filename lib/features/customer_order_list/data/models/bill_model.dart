import 'package:caterease/features/customer_order_list/domain/entities/bill_entity.dart';

class BillModel extends BillEntity {
  const BillModel({
    required super.billId,
    required super.orderId,
    required super.prepaymentPercentage,
    required super.prepaymentAmount,
    required super.totalAmount,
    required super.status,
    required super.issuedAt,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      billId: json['bill_id'] as int,
      orderId: json['order_id'] as int,
      prepaymentPercentage: json['prepayment_percentage'] as String,
      prepaymentAmount:
          (json['prepayment_amount'] as num).toDouble(), // ensure double
      totalAmount:
          double.parse(json['total_amount'].toString()), // handle string
      status: json['status'] as String,
      issuedAt: DateTime.parse(json['issued_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bill_id': billId,
      'order_id': orderId,
      'prepayment_percentage': prepaymentPercentage,
      'prepayment_amount': prepaymentAmount,
      'total_amount': totalAmount.toStringAsFixed(2),
      'status': status,
      'issued_at': issuedAt.toIso8601String(),
    };
  }
}
