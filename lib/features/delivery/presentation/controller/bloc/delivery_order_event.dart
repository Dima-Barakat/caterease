part of 'delivery_order_bloc.dart';

sealed class DeliveryOrderEvent extends Equatable {
  const DeliveryOrderEvent();

  @override
  List<Object> get props => [];
}

final class GetAllOrdersEvent extends DeliveryOrderEvent {}

final class GetOrderDetails extends DeliveryOrderEvent {}
