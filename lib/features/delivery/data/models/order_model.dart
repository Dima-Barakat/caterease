import 'package:caterease/features/orders/domain/entities/order.dart';
import 'package:caterease/features/profile/data/models/address_model.dart';

class OrderModel extends Order {
  const OrderModel(
      {required super.orderId,
      required super.status,
      required super.totalPrice,
      required super.createdAt,
      required super.createdSince,
      required super.customerName,
      required super.branchName,
      required super.restaurantName,
      super.items,
      super.address});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      status: json['status'],
      totalPrice: json['total_price'],
      createdAt: json['created_at'],
      createdSince: json['created_since'],
      customerName: json['customer_name'],
      branchName: json['branch_name'],
      restaurantName: json['restaurant_name'],
      items: json['items'],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'status': status,
      'total_price': totalPrice,
      'created_at': createdAt,
      'created_since': createdSince,
      'customer_name': customerName,
      'branch_name': branchName,
      'restaurant_name': restaurantName,
      'items': items,
      'address': (address as AddressModel).toJson(),
    };
  }
}
