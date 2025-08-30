part of 'delivery_order_bloc.dart';

sealed class DeliveryOrderState extends Equatable {
  const DeliveryOrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends DeliveryOrderState {}

final class OrderLoading extends DeliveryOrderState {}

final class OrderLoaded extends DeliveryOrderState {
  final OrderModel order;

  const OrderLoaded(this.order);

  @override
  List<Object> get props => [order];
}

final class OrderListLoaded extends DeliveryOrderState {
  final List<OrderModel> orders;
  const OrderListLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class OrderStatusUpdated extends DeliveryOrderState {
  final String message;
  const OrderStatusUpdated(this.message);

  @override
  List<Object> get props => [message];
}

final class OrderAccepted extends DeliveryOrderState {
  final String message;
  const OrderAccepted(this.message);

  @override
  List<Object> get props => [message];
}

final class OrderDeclined extends DeliveryOrderState {
  final String message;
  const OrderDeclined(this.message);

  @override
  List<Object> get props => [message];
}

final class OrderError extends DeliveryOrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

class LoadingScanCodeState extends DeliveryOrderState {}

class ErrorScanCodeState extends DeliveryOrderState {
  final String message;
  const ErrorScanCodeState({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccessScanCodeState extends DeliveryOrderState {
  final String message;
  const SuccessScanCodeState(this.message);

  @override
  List<Object> get props => [message];
}
