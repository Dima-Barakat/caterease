import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/domain/repositories/customer_order_list_repository.dart';
import 'package:dartz/dartz.dart';

class SubmitPaymentUseCase {
  final CustomerOrderListRepository repository;

  const SubmitPaymentUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String billId, String paymentType,
      String paymentMethod, double amount) async {
    return await repository.paymentBill(
        billId, paymentType, paymentMethod, amount);
  }
}
