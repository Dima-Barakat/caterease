import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/data/datasources/order_remote_data_source.dart';
import 'package:caterease/features/delivery/data/models/order_model.dart';
import 'package:caterease/features/delivery/domain/repositories/base_order_repository.dart';
import 'package:dartz/dartz.dart';

class OrderRepository implements BaseOrderRepository {
  final BaseOrderRemoteDataSource dataSource;

  OrderRepository({required this.dataSource});

  @override
  Future<Either<Failure, List<OrderModel>>> getAllOrders() async {
    try {
      final response = await dataSource.getAllOrders();
      return Right(response);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else {
        return Left(UnexpectedFailure("Unexpected error: ${e.toString()}"));
      }
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderDetails(int id) async {
    try {
      final response = await dataSource.getOrderDetails(id);
      return Right(response);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else {
        return Left(UnexpectedFailure("Unexpected error: ${e.toString()}"));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> changeOrderStatus(int id) async {
    try {
      await dataSource.changeOrderStatus(id);
      return const Right(unit);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else {
        return Left(UnexpectedFailure("Unexpected error: ${e.toString()}"));
      }
    }
  }
}
