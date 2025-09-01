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

//// Bill
class GetBill extends CustomerOrderListEvent {
  final String id;
  const GetBill(this.id);

  @override
  List<Object> get props => [id];
}

//// Payment
class EPayment extends CustomerOrderListEvent {
  final double amount;
  const EPayment({required this.amount});

  @override
  List<Object> get props => [amount];
}

class PayOrder extends CustomerOrderListEvent {
  final String billId;
  final String paymentType;
  final String paymentMethod;
  final double amount;
  const PayOrder(
      {required this.amount,
      required this.billId,
      required this.paymentMethod,
      required this.paymentType});

  @override
  List<Object> get props => [billId, amount, paymentMethod, paymentType];
}

class ApplyCouponEvent extends CustomerOrderListEvent {
  final int orderId;
  final String coupon;

  const ApplyCouponEvent({required this.orderId, required this.coupon});

  @override
  List<Object> get props => [orderId, coupon];
}
