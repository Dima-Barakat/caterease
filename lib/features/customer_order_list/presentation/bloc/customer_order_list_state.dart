import 'package:caterease/features/customer_order_list/data/models/bill_model.dart';
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

////Bill
class LoadingBill extends CustomerOrderListState {}

class SuccessBill extends CustomerOrderListState {
  final BillModel bill;

  const SuccessBill(this.bill);
  @override
  List<Object> get props => [bill];
}

class ErrorBill extends CustomerOrderListState {
  final String message;
  const ErrorBill(this.message);

  @override
  List<Object> get props => [message];
}

//// EPayment

class LoadingEPayment extends CustomerOrderListState {}

class SuccessEPayment extends CustomerOrderListState {
  final String data;
  const SuccessEPayment({required this.data});
  List<Object> get props => [data];
}

class ErrorEPayment extends CustomerOrderListState {
  final String message;
  const ErrorEPayment(this.message);
  @override
  List<Object> get props => [message];
}

//// Pay

class LoadingPay extends CustomerOrderListState {}

class SuccessPay extends CustomerOrderListState {
  List<Object> get props => [];
}

class ErrorPay extends CustomerOrderListState {
  final String message;
  const ErrorPay(this.message);
  @override
  List<Object> get props => [message];
}

class CouponSuccess extends CustomerOrderListState {}
