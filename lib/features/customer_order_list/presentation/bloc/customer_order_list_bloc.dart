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

  CustomerOrderListBloc({
    required this.getCustomerOrderListUseCase,
    required this.deleteOrderUseCase,
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
