import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_request.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_response.dart';
import 'package:caterease/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, AddToCartResponse>> call(
      AddToCartRequest request) async {
    return await repository.addToCart(request);
  }
}


