import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/usecases/usecase.dart';
import '../entities/remove_cart_item_response.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItemUseCase implements UseCase<RemoveCartItemResponse, int> {
  final CartRepository repository;

  RemoveCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, RemoveCartItemResponse>> call(int cartItemId) async {
    return await repository.removeCartItem(cartItemId);
  }
}

