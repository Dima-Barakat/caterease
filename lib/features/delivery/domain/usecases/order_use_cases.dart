import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/data/models/order_model.dart';
import 'package:caterease/features/delivery/domain/entities/scan_code.dart';
import 'package:caterease/features/delivery/domain/repositories/base_order_repository.dart';
import 'package:dartz/dartz.dart';

class OrderUseCases {
  final BaseOrderRepository repository;

  OrderUseCases(this.repository);

  Future<Either<Failure, List<OrderModel>>> getAllOrders() async {
    return await repository.getAllOrders();
  }

  Future<Either<Failure, OrderModel>> getOrderDetails(int id) async {
    return await repository.getOrderDetails(id);
  }

  Future<Either<Failure, Unit>> changeOrderStatus(int id, String status) async {
    return await repository.changeOrderStatus(id, status);
  }

  Future<Either<Failure, Unit>> acceptOrder(int id) async {
    return await repository.acceptOrder(id);
  }

  Future<Either<Failure, Unit>> declineOrder(
      int id, String rejectReason) async {
    return await repository.declineOrder(id, rejectReason);
  }

  Future<Either<Failure, Unit>> deliverOrder(String code, String? notes) async {
    return await repository.deliverOrder(code, notes);
  }
}
