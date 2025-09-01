import 'package:caterease/features/customer_order_list/data/models/bill_model.dart';
import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_order_list/domain/entities/customer_order_list_entity.dart';

abstract class CustomerOrderListRepository {
  Future<Either<Failure, List<CustomerOrderListEntity>>> getCustomerOrderList();
  Future<Either<Failure, bool>> deleteOrder(int orderId);
  Future<Either<Failure, String>> paymentCode(double amount);
  Future<Either<Failure, Unit>> paymentBill(
      String billId, String paymentType, String paymentMethod, double amount);
  Future<Either<Failure, BillModel>> getBill(String id);
  Future<Either<Failure, Unit>> applyCoupon(String id, String coupon);
}
