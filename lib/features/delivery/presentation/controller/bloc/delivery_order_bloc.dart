import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/orders/domain/entities/order.dart';
import 'package:caterease/features/delivery/domain/usecases/get_all_orders_use_case.dart';
import 'package:caterease/features/delivery/domain/usecases/get_order_details_use_case.dart';
import 'package:equatable/equatable.dart';

part 'delivery_order_event.dart';
part 'delivery_order_state.dart';

class DeliveryOrderBloc extends Bloc<DeliveryOrderEvent, DeliveryOrderState> {
  final GetAllOrdersUseCase getAllUseCase;
  final GetOrderDetailsUseCase getOneUseCase;

  DeliveryOrderBloc(this.getAllUseCase, this.getOneUseCase)
      : super(OrderInitial()) {
    on<GetAllOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final result = await getAllUseCase.getAllOrders();
        result.fold(
          (failure) => emit(OrderError(failure.toString())),
          (success) => emit(OrderListLoaded(success)),
        );
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<GetOrderDetails>((event, emit) async {
      emit(OrderLoading());

      try {
        final result = await getOneUseCase.getOrderDetails();

        result.fold(
          (failure) => emit(OrderError(failure.toString())),
          (success) => emit(OrderLoaded(success)),
        );
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });
  }
}
