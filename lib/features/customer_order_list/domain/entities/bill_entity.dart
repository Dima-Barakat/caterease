import 'package:equatable/equatable.dart';

class BillEntity extends Equatable {
  final int billId;
  final int orderId;
  final String prepaymentPercentage;
  final double prepaymentAmount;
  final double totalAmount;
  final String status;
  final DateTime issuedAt;

  const BillEntity({
    required this.billId,
    required this.orderId,
    required this.prepaymentPercentage,
    required this.prepaymentAmount,
    required this.totalAmount,
    required this.status,
    required this.issuedAt,
  });

  @override
  List<Object> get props => [
        billId,
        orderId,
        prepaymentAmount,
        prepaymentPercentage,
        totalAmount,
        status,
        issuedAt
      ];
}
