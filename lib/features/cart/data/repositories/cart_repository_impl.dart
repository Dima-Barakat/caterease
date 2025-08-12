import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_request.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_response.dart';
import 'package:caterease/features/cart/domain/entities/cart_packages.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_request.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_response.dart';
import 'package:caterease/features/cart/domain/entities/remove_cart_item_response.dart';
import 'package:caterease/features/cart/domain/repositories/cart_repository.dart';
import 'package:caterease/features/cart/data/models/add_to_cart_request_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AddToCartResponse>> addToCart(
      AddToCartRequest request) async {
    try {
      final requestModel = AddToCartRequestModel(
        packageId: request.packageId,
        quantity: request.quantity,
        extraPersons: request.extraPersons,
        occasionTypeId: request.occasionTypeId,
        serviceType:
            request.serviceType.map((e) => ServiceTypeModel(id: e.id)).toList(),
        extras: request.extras
            .map((e) => ExtraModel(extraId: e.extraId, quantity: e.quantity))
            .toList(),
      );

      final result = await remoteDataSource.addToCart(requestModel);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CartPackages>> getCartPackages() async {
    try {
      final result = await remoteDataSource.getCartPackages();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UpdateCartItemResponse>> updateCartItem(
      int cartItemId, UpdateCartItemRequest request) async {
    try {
      final result = await remoteDataSource.updateCartItem(cartItemId, request);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, RemoveCartItemResponse>> removeCartItem(
      int cartItemId) async {
    try {
      final result = await remoteDataSource.removeCartItem(cartItemId);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
