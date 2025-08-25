import 'package:dartz/dartz.dart' hide Order;
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_orders/domain/entities/customer_order.dart';
import 'package:caterease/features/customer_orders/domain/repositories/customer_order_repository.dart';

class CreateCustomerOrderUseCase {
  final CustomerOrderRepository repository;

  CreateCustomerOrderUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(CustomerOrder customerOrder) async {
    return await repository.createCustomerOrder(customerOrder);
  }
}

