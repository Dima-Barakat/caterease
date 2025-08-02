import 'package:bloc/bloc.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/cart/data/models/add_to_cart_request_model.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_request.dart';
import 'package:caterease/features/cart/domain/entities/add_to_cart_response.dart';
import 'package:caterease/features/cart/domain/entities/cart_packages.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_request.dart';
import 'package:caterease/features/cart/domain/entities/update_cart_item_response.dart';
import 'package:caterease/features/cart/domain/entities/remove_cart_item_response.dart';
import 'package:caterease/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/get_cart_packages_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/update_cart_item_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/remove_cart_item_use_case.dart';
import 'package:equatable/equatable.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final GetCartPackagesUseCase getCartPackagesUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;

  CartBloc({
    required this.addToCartUseCase,
    required this.getCartPackagesUseCase,
    required this.updateCartItemUseCase,
    required this.removeCartItemUseCase,
  }) : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCartEvent);
    on<GetCartPackagesEvent>(_onGetCartPackagesEvent);
    on<UpdateCartItemEvent>(_onUpdateCartItemEvent);
    on<RemoveCartItemEvent>(_onRemoveCartItemEvent);
  }
  
  void _onAddToCartEvent(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    print("Sending AddToCart request: ${event.request.toString()}");
    final result = await addToCartUseCase(event.request);
    result.fold(
      (failure) {
        print("AddToCart failed: ${_mapFailureToMessage(failure)}");
        emit(CartError(message: _mapFailureToMessage(failure)));
      },
      (response) {
        print("AddToCart success: ${response.message}");
        emit(AddToCartSuccess(response: response));
      },
    );
    // تحويل AddToCartRequest إلى AddToCartRequestModel
    final requestModel = AddToCartRequestModel(
      packageId: event.request.packageId,
      quantity: event.request.quantity,
      extraPersons: event.request.extraPersons,
      occasionTypeId: event.request.occasionTypeId,
      serviceType: event.request.serviceType
          .map((e) => ServiceTypeModel(id: e.id))
          .toList(),
      extras: event.request.extras
          .map((e) => ExtraModel(extraId: e.extraId, quantity: e.quantity))
          .toList(),
    );

    print(
        "AddToCartRequest ****************************   JSON: ${requestModel.toJson()}"); // استخدام requestModel.toJson()
  }

  void _onGetCartPackagesEvent(
    GetCartPackagesEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    print('Getting cart packages');
    final result = await getCartPackagesUseCase();
    result.fold(
      (failure) {
        print('GetCartPackages failed: ${_mapFailureToMessage(failure)}');
        emit(CartError(message: _mapFailureToMessage(failure)));
      },
      (cartPackages) {
        print('GetCartPackages success: ${cartPackages.data.length} packages');
        emit(GetCartPackagesSuccess(cartPackages: cartPackages));
      },
    );
  }

  void _onUpdateCartItemEvent(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    print('Updating cart item: ${event.cartItemId}');
    final result = await updateCartItemUseCase(
      UpdateCartItemParams(
        cartItemId: event.cartItemId,
        request: event.request,
      ),
    );
    result.fold(
      (failure) {
        print('UpdateCartItem failed: ${_mapFailureToMessage(failure)}');
        emit(CartError(message: _mapFailureToMessage(failure)));
      },
      (response) {
        print('UpdateCartItem success: ${response.message}');
        emit(UpdateCartItemSuccess(response: response));
      },
    );
  }

  void _onRemoveCartItemEvent(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    print('Removing cart item: ${event.cartItemId}');
    final result = await removeCartItemUseCase(event.cartItemId);
    result.fold(
      (failure) {
        print('RemoveCartItem failed: ${_mapFailureToMessage(failure)}');
        emit(CartError(message: _mapFailureToMessage(failure)));
      },
      (response) {
        print('RemoveCartItem success: ${response.message}');
        emit(RemoveCartItemSuccess(response: response));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
