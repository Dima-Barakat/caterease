import 'package:caterease/features/customer_orders/domain/entities/customer_order.dart';

class CustomerOrderModel extends CustomerOrder {
  const CustomerOrderModel({
    required super.notes,
    required super.deliveryTime,
    required super.cartItemIds,
    required super.address,
  });

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrderModel(
      notes: json['notes'] ?? '',
      deliveryTime: json['delivery_time'] ?? '',
      cartItemIds: List<int>.from(json['cart_item_ids'] ?? []),
      address: Map<String, dynamic>.from(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notes': notes,
      'delivery_time': deliveryTime,
      'cart_item_ids': cartItemIds,
      'address': address,
    };
  }

  factory CustomerOrderModel.fromEntity(CustomerOrder customerOrder) {
    return CustomerOrderModel(
      notes: customerOrder.notes,
      deliveryTime: customerOrder.deliveryTime,
      cartItemIds: customerOrder.cartItemIds,
      address: customerOrder.address,
    );
  }
}

