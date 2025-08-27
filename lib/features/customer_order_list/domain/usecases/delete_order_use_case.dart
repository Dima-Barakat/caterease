import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/usecases/usecase.dart';
import 'package:caterease/features/customer_order_list/domain/repositories/customer_order_list_repository.dart';

class DeleteOrderUseCase implements UseCase<bool, int> {
  final CustomerOrderListRepository repository;

  DeleteOrderUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(int orderId) async {
    return await repository.deleteOrder(orderId);
  }
}

