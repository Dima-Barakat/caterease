import 'package:equatable/equatable.dart';

abstract class CustomerOrderListEvent extends Equatable {
  const CustomerOrderListEvent();

  @override
  List<Object> get props => [];
}

class GetCustomerOrderList extends CustomerOrderListEvent {}

class DeleteOrder extends CustomerOrderListEvent {
  final int orderId;

  const DeleteOrder({required this.orderId});

  @override
  List<Object> get props => [orderId];
}


