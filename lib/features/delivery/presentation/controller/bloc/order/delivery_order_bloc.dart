import 'package:caterease/features/delivery/data/models/order_model.dart';
import 'package:caterease/features/delivery/domain/entities/scan_code.dart';
import 'package:caterease/features/delivery/domain/usecases/order_use_cases.dart';
import 'package:caterease/features/order_details_feature/presentation/bloc/order_details_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'delivery_order_event.dart';
part 'delivery_order_state.dart';

class DeliveryOrderBloc extends Bloc<DeliveryOrderEvent, DeliveryOrderState> {
  final OrderUseCases useCases;

  DeliveryOrderBloc(this.useCases) : super(OrderInitial()) {
    on<GetAllOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final result = await useCases.getAllOrders();
        result.fold(
          (failure) => emit(OrderError(failure.toString())),
          (success) => emit(OrderListLoaded(success)),
        );
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<GetOrderDetailsEvent>((event, emit) async {
      emit(OrderLoading());

      try {
        final result = await useCases.getOrderDetails(event.id);

        result.fold(
          (failure) => emit(OrderError(failure.toString())),
          (success) => emit(OrderLoaded(success)),
        );
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<UpdateStatusOrderEvent>((event, emit) async {
      try {
        emit(OrderLoading());

        final result = await useCases.changeOrderStatus(event.id, event.status);

        if (result.isLeft()) {
          final failure = result.fold((f) => f, (_) => null);
          emit(OrderError(failure.toString()));
        } else {
          emit(const OrderStatusUpdated("Order Status Updated"));

          final order = await useCases.getOrderDetails(event.id);
          order.fold(
            (failure) => emit(OrderError(failure.toString())),
            (success) => emit(OrderLoaded(success)),
          );
        }
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<AcceptOrder>((event, emit) async {
      try {
        emit(OrderLoading());

        final result = await useCases.acceptOrder(event.id);

        if (result.isLeft()) {
          final failure = result.fold((f) => f, (_) => null);
          emit(OrderError(failure.toString()));
        } else {
          emit(const OrderAccepted("Order accepted"));

          final orders = await useCases.getAllOrders();

          orders.fold(
            (failure) => emit(OrderError(failure.toString())),
            (success) => emit(OrderListLoaded(success)),
          );
        }
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<DeclineOrder>((event, emit) async {
      try {
        emit(OrderLoading());
        await useCases.declineOrder(event.id, event.rejectReason);

        // reload orders after decline
        final orders = await useCases.getAllOrders();

        orders.fold(
          (failure) => emit(OrderError(failure.toString())),
          (success) {
            emit(const OrderDeclined("Order declined"));
            emit(OrderListLoaded(success));
          },
        );
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<ScanCodeEvent>((event, emit) async {
      emit(LoadingScanCodeState());
      final failureORdone = await useCases.deliverOrder(event.code, event.note);
      failureORdone.fold(
          (failure) => {emit(ErrorScanCodeState(message: failure.toString()))},
          (order) => {emit(const SuccessScanCodeState("Delivery Completed"))});
    });
  }
}
