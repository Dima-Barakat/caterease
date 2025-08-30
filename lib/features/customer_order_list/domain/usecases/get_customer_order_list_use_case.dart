import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/domain/entities/customer_order_list_entity.dart';
import 'package:caterease/features/customer_order_list/domain/repositories/customer_order_list_repository.dart';

class GetCustomerOrderListUseCase {
  final CustomerOrderListRepository repository;

  GetCustomerOrderListUseCase({required this.repository});

  Future<Either<Failure, List<CustomerOrderListEntity>>> call() async {
    return await repository.getCustomerOrderList();
  }
}


