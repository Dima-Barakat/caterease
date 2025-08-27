import 'package:caterease/features/profile/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final OrderInfo order;
  final UserInfo user;
  final RestaurantInfo restaurant;

  const Order({
    required this.order,
    required this.user,
    required this.restaurant,
  });

  @override
  List<Object> get props => [order, user, restaurant];
}

class OrderInfo extends Equatable {
  final int id;
  final String status;
  final String totalPrice;
  final String createdAt;
  final String createdSince;
  final String? items;
  final int? isAccepted;

  const OrderInfo(
      {required this.id,
      required this.status,
      required this.totalPrice,
      required this.createdAt,
      required this.createdSince,
      this.items,
      this.isAccepted});

  @override
  List<Object?> get props =>
      [id, status, totalPrice, createdAt, createdSince, items];
}

class UserInfo extends Equatable {
  final String name;
  final String phone;
  final Address address;

  const UserInfo({
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  List<Object> get props => [name, phone, address];
}

class RestaurantInfo extends Equatable {
  final String name;
  final String branch;
  final String? location;

  const RestaurantInfo({
    required this.name,
    required this.branch,
    this.location,
  });

  @override
  List<Object?> get props => [name, location, branch];
}
