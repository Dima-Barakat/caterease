import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/data/models/order_model.dart';
import 'package:caterease/features/delivery/domain/repositories/base_order_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllOrdersUseCase {
  final BaseOrderRepository repository;
  GetAllOrdersUseCase({required this.repository});

  Future<Either<Failure, List<OrderModel>>> getAllOrders() async {
    return await repository.getAllOrders();
  }
}
