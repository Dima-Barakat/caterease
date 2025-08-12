import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_request.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_response.dart';
import 'package:caterease/features/cart/domain/entities/cart_packages.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_request.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_response.dart';
import 'package:caterease/features/cart/domain/entities/remove_cart_item_response.dart';

abstract class CartRepository {
  Future<Either<Failure, AddToCartResponse>> addToCart(
      AddToCartRequest request);
  Future<Either<Failure, CartPackages>> getCartPackages();
  Future<Either<Failure, UpdateCartItemResponse>> updateCartItem(
      int cartItemId, UpdateCartItemRequest request);
  Future<Either<Failure, RemoveCartItemResponse>> removeCartItem(
      int cartItemId);
}
