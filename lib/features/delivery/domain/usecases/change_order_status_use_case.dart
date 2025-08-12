import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/domain/repositories/base_order_repository.dart';
import 'package:dartz/dartz.dart';

class ChangeOrderStatusUseCase {
  final BaseOrderRepository repository;
  ChangeOrderStatusUseCase({required this.repository});

  Future<Either<Failure, Unit>> changeOrderStatus(int id) async {
    return await repository.changeOrderStatus(id);
  }
}
