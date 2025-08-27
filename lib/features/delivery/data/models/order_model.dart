import 'package:caterease/features/delivery/domain/entities/order.dart';
import 'package:caterease/features/profile/data/models/address_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.order,
    required super.user,
    required super.restaurant,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final orderJson = json['order'];
    final userJson = json['user'];
    final restaurantJson = json['restaurant'];

    return OrderModel(
      order: OrderInfo(
        id: orderJson['id'],
        status: orderJson['status'],
        totalPrice: orderJson['total_price'],
        createdAt: orderJson['created_at'],
        createdSince: orderJson['created_since'],
        items: orderJson['items'],
        isAccepted: orderJson['is_accepted'],
      ),
      user: UserInfo(
        name: userJson['name'],
        phone: userJson['phone'],
        address: AddressModel.fromJson(userJson['address']),
      ),
      restaurant: RestaurantInfo(
        name: restaurantJson['name'],
        branch: restaurantJson['branch'],
        location: restaurantJson['location'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': {
        'id': order.id,
        'status': order.status,
        'total_price': order.totalPrice,
        'created_at': order.createdAt,
        'created_since': order.createdSince,
        'items': order.items,
      },
      'user': {
        'name': user.name,
        'phone': user.phone,
        'address': (user.address as AddressModel).toJson(),
      },
      'restaurant': {
        'name': restaurant.name,
        'branch': restaurant.branch,
      }
    };
  }
}
