import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/network/network_info.dart';
import 'package:caterease/features/customer_order_list/data/datasources/customer_order_list_remote_data_source.dart';
import 'package:caterease/features/customer_order_list/domain/entities/customer_order_list_entity.dart';
import 'package:caterease/features/customer_order_list/domain/repositories/customer_order_list_repository.dart';

class CustomerOrderListRepositoryImpl implements CustomerOrderListRepository {
  final CustomerOrderListRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CustomerOrderListRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CustomerOrderListEntity>>>
      getCustomerOrderList() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await remoteDataSource.getCustomerOrderList();
        return Right(remoteOrders);
      } on ServerException catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteOrder(int orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deleteOrder(orderId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
