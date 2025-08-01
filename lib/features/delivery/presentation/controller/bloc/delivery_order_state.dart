part of 'delivery_order_bloc.dart';

sealed class DeliveryOrderState extends Equatable {
  const DeliveryOrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends DeliveryOrderState {}

final class OrderLoading extends DeliveryOrderState {}

final class OrderLoaded extends DeliveryOrderState {
  final Order order;

  const OrderLoaded(this.order);

  @override
  List<Object> get props => [order];
}

final class OrderListLoaded extends DeliveryOrderState {
  final List<Order> orders;
  const OrderListLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class OrderUpdated extends DeliveryOrderState {}

final class OrderError extends DeliveryOrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
