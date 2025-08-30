import 'package:bloc/bloc.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/order_details_feature/domain/entities/order_details_entity.dart';
import 'package:caterease/features/order_details_feature/domain/usecases/get_order_details_usecase.dart';
import 'package:equatable/equatable.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final GetOrderDetailsUseCase getOrderDetailsUseCase;

  OrderDetailsBloc({required this.getOrderDetailsUseCase})
      : super(OrderDetailsInitial()) {
    on<GetOrderDetails>((event, emit) async {
      emit(OrderDetailsLoading());
      final failureOrOrderDetails =
          await getOrderDetailsUseCase(Params(orderId: event.orderId));
      failureOrOrderDetails.fold(
        (failure) => emit(OrderDetailsError(_mapFailureToMessage(failure))),
        (orderDetails) => emit(OrderDetailsLoaded(orderDetails)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Server Failure";
/*       case NetworkFailure:
        return "Network Failure"; */
      default:
        return "Unexpected Error";
    }
  }
}
