import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/domain/entities/customer_order_list_entity.dart';

abstract class CustomerOrderListRepository {
  Future<Either<Failure, List<CustomerOrderListEntity>>> getCustomerOrderList();
  Future<Either<Failure, bool>> deleteOrder(int orderId);
}


