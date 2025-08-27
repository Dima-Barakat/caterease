import 'package:equatable/equatable.dart';
import 'package:caterease/features/customer_orders/domain/entities/customer_order.dart';

abstract class CustomerOrderEvent extends Equatable {
  const CustomerOrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderEvent extends CustomerOrderEvent {
  final CustomerOrder customerOrder;

  const CreateOrderEvent({required this.customerOrder});

  @override
  List<Object?> get props => [customerOrder];
}

class ResetOrderStateEvent extends CustomerOrderEvent {
  const ResetOrderStateEvent();
}

