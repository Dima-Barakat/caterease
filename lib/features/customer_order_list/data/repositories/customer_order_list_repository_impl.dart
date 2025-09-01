import 'package:caterease/features/customer_order_list/data/models/bill_model.dart';
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
    try {
      final remoteOrders = await remoteDataSource.getCustomerOrderList();
      return Right(remoteOrders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
    /*  if (await networkInfo.isConnected) {
      
    } else {
      return Left(NetworkFailure());
    } */
  }

  @override
  Future<Either<Failure, bool>> deleteOrder(int orderId) async {
    try {
      final result = await remoteDataSource.deleteOrder(orderId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
    /*   if (await networkInfo.isConnected) {
      
    } else {
      return Left(NetworkFailure());
    } */
  }

  @override
  Future<Either<Failure, String>> paymentCode(double amount) async {
    try {
      final result = await remoteDataSource.paymentCode(amount);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> paymentBill(String billId, String paymentType,
      String paymentMethod, double amount) async {
    try {
      await remoteDataSource.paymentBill(
          billId, paymentType, paymentMethod, amount);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BillModel>> getBill(String id) async {
    try {
      final bill = await remoteDataSource.getBill(id);
      return Right(bill);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> applyCoupon(String id, String coupon) async {
    try {
      await remoteDataSource.applyCoupon(id, coupon);
      return Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
