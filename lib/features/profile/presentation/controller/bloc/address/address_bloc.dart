import 'package:caterease/features/profile/domain/usecases/address/address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressUseCase useCase;

  AddressBloc(this.useCase) : super(AddressInitial()) {
    on<LoadCitiesEvent>((event, emit) async {
      try {
        final result = await useCase.getAllCities();
        result.fold(
          (failure) => emit(AddressError(failure.toString())),
          (success) => emit(CitiesLoaded(success)),
        );
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });

    on<LoadDistrictsEvent>((event, emit) async {
      try {
        final result = await useCase.getAllDistricts(event.cityId);
        result.fold(
          (failure) => emit(AddressError(failure.toString())),
          (success) => emit(DistrictsLoaded(success)),
        );
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });

    on<LoadAreasEvent>((event, emit) async {
      try {
        final result = await useCase.getAllAreas(event.districtId);
        result.fold(
          (failure) => emit(AddressError(failure.toString())),
          (success) => emit(AreasLoaded(success)),
        );
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });

    on<GetAllAddressesEvent>((event, emit) async {
      try {
        final result = await useCase.getAllAddresses();
        result.fold(
          (failure) => emit(AddressError(failure.toString())),
          (success) => emit(AddressLoaded(success)),
        );
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });

    on<CreateAddressEvent>((event, emit) async {
      emit(AddressLoading());
      try {
        final result = await useCase.createAddress(
          cityId: event.cityId,
          areaId: event.areaId,
          districtId: event.districtId,
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
        final result = await useCase.deleteAddress(id: event.id);
        result.fold((failure) => emit(AddressError(failure.toString())),
            (success) => emit(AddressDeleted()));
      } catch (e) {
        emit(AddressError(e.toString()));
      }
    });
  }
}
