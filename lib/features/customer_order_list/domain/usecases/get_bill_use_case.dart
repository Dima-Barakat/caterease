import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/data/models/bill_model.dart';
import 'package:caterease/features/customer_order_list/domain/repositories/customer_order_list_repository.dart';
import 'package:dartz/dartz.dart';

class GetBillUseCase {
  final CustomerOrderListRepository repository;

  GetBillUseCase(this.repository);

  Future<Either<Failure, BillModel>> call(String id) async {
    return await repository.getBill(id);
  }
}
