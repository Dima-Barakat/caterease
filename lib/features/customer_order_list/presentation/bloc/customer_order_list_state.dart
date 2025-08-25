import 'package:equatable/equatable.dart';
import 'package:caterease/features/customer_order_list/domain/entities/customer_order_list_entity.dart';

abstract class CustomerOrderListState extends Equatable {
  const CustomerOrderListState();

  @override
  List<Object> get props => [];
}

class CustomerOrderListInitial extends CustomerOrderListState {}

class CustomerOrderListLoading extends CustomerOrderListState {}

class CustomerOrderListLoaded extends CustomerOrderListState {
  final List<CustomerOrderListEntity> orders;

  const CustomerOrderListLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class CustomerOrderListError extends CustomerOrderListState {
  final String message;

  const CustomerOrderListError({required this.message});

  @override
  List<Object> get props => [message];
}

class OrderDeleting extends CustomerOrderListState {
  final int orderId;

  const OrderDeleting({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

class OrderDeleted extends CustomerOrderListState {
  final int orderId;
  final String message;

  const OrderDeleted({required this.orderId, required this.message});

  @override
  List<Object> get props => [orderId, message];
}


