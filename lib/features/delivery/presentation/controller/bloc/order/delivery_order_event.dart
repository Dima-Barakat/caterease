part of 'delivery_order_bloc.dart';

sealed class DeliveryOrderEvent extends Equatable {
  const DeliveryOrderEvent();

  @override
  List<Object> get props => [];
}

final class GetAllOrdersEvent extends DeliveryOrderEvent {}

final class GetOrderDetailsEvent extends DeliveryOrderEvent {
  final int id;

  const GetOrderDetailsEvent({required this.id});

  @override
  List<Object> get props => [id];
}

final class UpdateStatusOrderEvent extends DeliveryOrderEvent {
  final int id;
  final String status;

  const UpdateStatusOrderEvent(this.id, this.status);

  @override
  List<Object> get props => [id, status];
}

final class AcceptOrder extends DeliveryOrderEvent {
  final int id;
  const AcceptOrder(this.id);

  @override
  List<Object> get props => [id];
}

final class DeclineOrder extends DeliveryOrderEvent {
  final int id;
  final String rejectReason;
  const DeclineOrder(this.id, this.rejectReason);

  @override
  List<Object> get props => [id, rejectReason];
}

