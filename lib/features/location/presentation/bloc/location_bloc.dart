
import "package:flutter_bloc/flutter_bloc.dart";
import "package:equatable/equatable.dart";
import "package:geolocator/geolocator.dart";
import "../../../../core/usecases/usecase.dart";
import "../../domain/usecases/get_current_location.dart";
import "../../domain/usecases/request_location_permission.dart";

part "location_event.dart";
part "location_state.dart";

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final RequestLocationPermission requestLocationPermission;

  LocationBloc({
    required this.getCurrentLocation,
    required this.requestLocationPermission,
  }) : super(LocationInitial()) {
    on<RequestLocationPermissionEvent>(_onRequestLocationPermission);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
  }

  Future<void> _onRequestLocationPermission(
    RequestLocationPermissionEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await requestLocationPermission(NoParams());
    result.fold(
      (failure) => emit(LocationError("فشل في طلب إذن الموقع")),
      (granted) => granted
          ? emit(LocationPermissionGranted())
          : emit(LocationError("تم رفض إذن الموقع")),
    );
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await getCurrentLocation(NoParams());
    result.fold(
      (failure) => emit(LocationError("فشل في الحصول على الموقع الحالي")),
      (position) => emit(LocationLoaded(position)),
    );
  }
}


