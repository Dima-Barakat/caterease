import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/domain/repositories/customer_order_list_repository.dart';
import 'package:dartz/dartz.dart';

class ApplyCouponUseCase {
  final CustomerOrderListRepository repository;

  ApplyCouponUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id, String coupon) async {
    return await repository.applyCoupon(id, coupon);
  }
}
