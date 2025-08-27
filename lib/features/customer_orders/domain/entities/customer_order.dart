import 'package:equatable/equatable.dart';

class CustomerOrder extends Equatable {
  final String notes;
  final String deliveryTime;
  final List<int> cartItemIds;
  final Map<String, dynamic> address;

  const CustomerOrder({
    required this.notes,
    required this.deliveryTime,
    required this.cartItemIds,
    required this.address,
  });

  @override
  List<Object?> get props => [notes, deliveryTime, cartItemIds, address];
}



