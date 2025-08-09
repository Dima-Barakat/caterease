import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/data/models/order_model.dart';
import 'package:caterease/features/delivery/domain/repositories/base_order_repository.dart';
import 'package:dartz/dartz.dart';

class GetOrderDetailsUseCase {
  final BaseOrderRepository repository;
  GetOrderDetailsUseCase({required this.repository});

  Future<Either<Failure, OrderModel>> getOrderDetails(int id) async {
    return await repository.getOrderDetails(id);
  }
}
