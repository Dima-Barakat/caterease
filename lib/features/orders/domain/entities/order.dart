import 'package:caterease/features/profile/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int orderId;
  final String status;
  final String totalPrice;
  final String createdAt;
  final String createdSince;
  final String customerName;
  final String restaurantName;
  final String branchName;
  final String? items;
  final Address? address;

  const Order({
    required this.orderId,
    required this.customerName,
    required this.restaurantName,
    required this.branchName,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.createdSince,
    this.items,
    this.address,
  });
  @override
  List<Object> get props => [];
}
