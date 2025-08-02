part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final AddToCartRequest request;

  const AddToCartEvent({required this.request});

  @override
  List<Object> get props => [request];
}

class GetCartPackagesEvent extends CartEvent {
  const GetCartPackagesEvent();
}

class UpdateCartItemEvent extends CartEvent {
  final int cartItemId;
  final UpdateCartItemRequest request;

  const UpdateCartItemEvent({
    required this.cartItemId,
    required this.request,
  });

  @override
  List<Object> get props => [cartItemId, request];
}

class RemoveCartItemEvent extends CartEvent {
  final int cartItemId;

  const RemoveCartItemEvent({required this.cartItemId});

  @override
  List<Object> get props => [cartItemId];
}
