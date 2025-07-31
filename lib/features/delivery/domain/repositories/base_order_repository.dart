import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/data/models/order_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseOrderRepository {
  Future<Either<Failure, List<OrderModel>>> getAllOrders();

  Future<Either<Failure, OrderModel>> getOrderDetails();
}
