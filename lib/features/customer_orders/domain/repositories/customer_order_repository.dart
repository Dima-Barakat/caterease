import 'package:dartz/dartz.dart' hide Order;
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_orders/domain/entities/customer_order.dart';

abstract class CustomerOrderRepository {
  Future<Either<Failure, Unit>> createCustomerOrder(CustomerOrder customerOrder);
}

