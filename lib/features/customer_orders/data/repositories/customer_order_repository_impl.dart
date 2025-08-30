import 'package:dartz/dartz.dart' hide Order;
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/customer_orders/domain/entities/customer_order.dart';
import 'package:caterease/features/customer_orders/domain/repositories/customer_order_repository.dart';
import 'package:caterease/features/customer_orders/data/datasources/customer_order_remote_data_source.dart';
import 'package:caterease/features/customer_orders/data/models/customer_order_model.dart';

class CustomerOrderRepositoryImpl implements CustomerOrderRepository {
  final CustomerOrderRemoteDataSource remoteDataSource;

  CustomerOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> createCustomerOrder(
      CustomerOrder customerOrder) async {
    try {
      final customerOrderModel = CustomerOrderModel.fromEntity(customerOrder);
      await remoteDataSource.createCustomerOrder(customerOrderModel.toJson());
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
