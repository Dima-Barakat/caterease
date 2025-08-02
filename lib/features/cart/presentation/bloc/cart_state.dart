part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class AddToCartSuccess extends CartState {
  final AddToCartResponse response;

  const AddToCartSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class GetCartPackagesSuccess extends CartState {
  final CartPackages cartPackages;

  const GetCartPackagesSuccess({required this.cartPackages});

  @override
  List<Object> get props => [cartPackages];
}

class UpdateCartItemSuccess extends CartState {
  final UpdateCartItemResponse response;

  const UpdateCartItemSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class RemoveCartItemSuccess extends CartState {
  final RemoveCartItemResponse response;

  const RemoveCartItemSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}


