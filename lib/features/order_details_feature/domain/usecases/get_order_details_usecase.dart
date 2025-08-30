import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/usecases/usecase.dart';
import 'package:caterease/features/order_details_feature/domain/entities/order_details_entity.dart';
import 'package:caterease/features/order_details_feature/domain/repositories/order_details_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetOrderDetailsUseCase implements UseCase<OrderDetailsEntity, Params> {
  final OrderDetailsRepository repository;

  GetOrderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, OrderDetailsEntity>> call(Params params) async {
    return await repository.getOrderDetails(params.orderId);
  }
}

class Params extends Equatable {
  final int orderId;

  const Params({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
