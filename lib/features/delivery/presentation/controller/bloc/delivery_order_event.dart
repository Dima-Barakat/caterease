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

  const UpdateStatusOrderEvent({required this.id});

  @override
  List<Object> get props => [id];
}
