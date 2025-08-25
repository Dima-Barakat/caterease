import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/order_details_feature/domain/entities/order_details_entity.dart';
import 'package:dartz/dartz.dart';

abstract class OrderDetailsRepository {
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails(int orderId);
}
