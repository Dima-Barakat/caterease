import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/usecases/usecase.dart';
import '../entities/update_cart_item_request.dart';
import '../entities/update_cart_item_response.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItemUseCase implements UseCase<UpdateCartItemResponse, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, UpdateCartItemResponse>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(params.cartItemId, params.request);
  }
}

class UpdateCartItemParams {
  final int cartItemId;
  final UpdateCartItemRequest request;

  UpdateCartItemParams({
    required this.cartItemId,
    required this.request,
  });
}

