part of "order_details_bloc.dart";

abstract class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetOrderDetails extends OrderDetailsEvent {
  final int orderId;

  const GetOrderDetails({required this.orderId});

  @override
  List<Object> get props => [orderId];
}


