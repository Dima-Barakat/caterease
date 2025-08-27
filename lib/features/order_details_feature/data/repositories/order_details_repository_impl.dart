import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/order_details_feature/data/datasources/order_details_remote_data_source.dart';
import 'package:caterease/features/order_details_feature/domain/entities/order_details_entity.dart';
import 'package:caterease/features/order_details_feature/domain/repositories/order_details_repository.dart';
import 'package:dartz/dartz.dart';

class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  final OrderDetailsRemoteDataSource remoteDataSource;

  OrderDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails(
      int orderId) async {
    try {
      final remoteOrderDetails =
          await remoteDataSource.getOrderDetails(orderId);
      return Right(remoteOrderDetails);
    } on ServerException {
      return const Left(
          ServerFailure("Failed to get order details from server."));
    } on Exception {
      return const Left(UnexpectedFailure("An unexpected error occurred."));
    }
  }
}
