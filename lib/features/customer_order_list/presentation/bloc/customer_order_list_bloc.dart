import 'package:caterease/features/customer_order_list/domain/usecases/apply_coupon_use_case.dart';
import 'package:caterease/features/customer_order_list/domain/usecases/get_bill_use_case.dart';
import 'package:caterease/features/customer_order_list/domain/usecases/get_payment_code_use_case.dart';
import 'package:caterease/features/customer_order_list/domain/usecases/submit_payment_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/domain/usecases/get_customer_order_list_use_case.dart';
import 'package:caterease/features/customer_order_list/domain/usecases/delete_order_use_case.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_event.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String NETWORK_FAILURE_MESSAGE = 'Network Failure';

class CustomerOrderListBloc
    extends Bloc<CustomerOrderListEvent, CustomerOrderListState> {
  final GetCustomerOrderListUseCase getCustomerOrderListUseCase;
  final DeleteOrderUseCase deleteOrderUseCase;
  final GetPaymentCodeUseCase getPaymentCodeUseCase;
  final SubmitPaymentUseCase submitPaymentUseCase;
  final GetBillUseCase getBillUseCase;
  final ApplyCouponUseCase applyCouponUseCase;

  CustomerOrderListBloc({
    required this.getCustomerOrderListUseCase,
    required this.deleteOrderUseCase,
    required this.getPaymentCodeUseCase,
    required this.getBillUseCase,
    required this.applyCouponUseCase,
    required this.submitPaymentUseCase,
  }) : super(CustomerOrderListInitial()) {
    on<GetCustomerOrderList>((event, emit) async {
      emit(CustomerOrderListLoading());
      final failureOrOrders = await getCustomerOrderListUseCase();
      failureOrOrders.fold(
        (failure) => emit(
            CustomerOrderListError(message: _mapFailureToMessage(failure))),
        (orders) => emit(CustomerOrderListLoaded(orders: orders)),
      );
    });

    on<DeleteOrder>((event, emit) async {
      emit(OrderDeleting(orderId: event.orderId));
      final failureOrSuccess = await deleteOrderUseCase(event.orderId);
      failureOrSuccess.fold(
        (failure) => emit(
            CustomerOrderListError(message: _mapFailureToMessage(failure))),
        (success) {
          emit(OrderDeleted(
              orderId: event.orderId, message: "Order deleted successfully."));
          // Refresh the order list after deletion
          add(GetCustomerOrderList());
        },
      );
    });
    on<EPayment>((event, emit) async {
      final failureOrDone = await getPaymentCodeUseCase(event.amount);
      failureOrDone.fold(
        (failure) => emit(
            ErrorEPayment(failure.message ?? 'some thing goes wrong in EPay')),
        (success) {
          emit(SuccessEPayment(data: success));
        },
      );
    });

    on<PayOrder>((event, emit) async {
      final failureOrDone = await submitPaymentUseCase(
          event.billId, event.paymentMethod, event.paymentType, event.amount);
      failureOrDone.fold(
        (failure) => emit(
            ErrorPay(failure.message ?? 'some thing goes wrong Pay order')),
        (success) {
          emit(SuccessPay());
        },
      );
    });

    on<GetBill>((event, emit) async {
      final failOrSuccess = await getBillUseCase(event.id);
      failOrSuccess.fold(
          (failure) => emit(
              ErrorBill(failure.message ?? 'something goes wrong in Get Bill')),
          (success) => emit(SuccessBill(success)));
    });

    on<ApplyCouponEvent>((event, emit) async {
      emit(CustomerOrderListLoading());

      final result =
          await applyCouponUseCase(event.orderId.toString(), event.coupon);
      result.fold(
        (failure) => emit(CustomerOrderListError(
            message: failure.message ?? "Failed to apply coupon")),
        (success) {
          emit(CouponSuccess()); 
        },
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;

      /*      case NetworkFailure:
        return NETWORK_FAILURE_MESSAGE; */
      default:
        return 'Unexpected error';
    }
  }
}
