import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/domain/repositories/customer_order_list_repository.dart';
import 'package:dartz/dartz.dart';

class GetPaymentCodeUseCase {
  final CustomerOrderListRepository repository;

  const GetPaymentCodeUseCase(this.repository);

  Future<Either<Failure, String >> call(double amount) async {
    return await repository.paymentCode(amount);
  }
}
