import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/customer_orders/domain/usecases/create_customer_order_use_case.dart';
import 'package:caterease/features/customer_orders/presentation/bloc/customer_order_event.dart';
import 'package:caterease/features/customer_orders/presentation/bloc/customer_order_state.dart';

class CustomerOrderBloc extends Bloc<CustomerOrderEvent, CustomerOrderState> {
  final CreateCustomerOrderUseCase createCustomerOrderUseCase;

  CustomerOrderBloc({required this.createCustomerOrderUseCase})
      : super(const CustomerOrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<ResetOrderStateEvent>(_onResetOrderState);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<CustomerOrderState> emit,
  ) async {
    emit(const CustomerOrderLoading());

    final result = await createCustomerOrderUseCase(event.customerOrder);

    result.fold(
      (failure) => emit(CustomerOrderError(message: "failure.message")),
      (_) => emit(const CustomerOrderSuccess(message: 'تم إنشاء الطلب بنجاح')),
    );
  }

  void _onResetOrderState(
    ResetOrderStateEvent event,
    Emitter<CustomerOrderState> emit,
  ) {
    emit(const CustomerOrderInitial());
  }
}
