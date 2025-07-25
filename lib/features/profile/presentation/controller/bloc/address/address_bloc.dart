import 'package:caterease/features/profile/domain/usecases/address/create_address_use_case.dart';
import 'package:caterease/features/profile/domain/usecases/address/delete_address_use_case.dart';
import 'package:caterease/features/profile/domain/usecases/address/index_addresses_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final IndexAddressesUseCase index;
  final CreateAddressUseCase create;
  final DeleteAddressUseCase delete;

  AddressBloc(this.create, this.delete, this.index) : super(AddressInitial()) {
    on<GetAllAddressesEvent>((event, emit) {
      emit(AddressInitial());
    });

    on<CreateAddressEvent>((event, emit) async {
      emit(AddressLoading());
      try {
        final result = await create.createAddress(
          cityId: event.cityId,
          street: event.street,
          building: event.building,
          floor: event.floor,
          apartment: event.apartment,
          lat: event.lat,
          long: event.long,
        );
        result.fold(
          (failure) => emit(AddressError(failure.toString())),
          (success) => emit(AddressCreated()),
        );
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });

    on<DeleteAddressEvent>((event, emit) async {
      emit(AddressLoading());

      try {
        final result = await delete.deleteAddress(id: event.id);
        result.fold((failure) => emit(AddressError(failure.toString())),
            (success) => emit(AddressDeleted()));
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });
  }
}
