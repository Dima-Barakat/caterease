import "package:flutter_bloc/flutter_bloc.dart";
import "package:equatable/equatable.dart";
import "package:geolocator/geolocator.dart";
import "../../../../core/usecases/usecase.dart";
import "../../domain/usecases/get_current_location.dart";
import "../../domain/usecases/request_location_permission.dart";
import "../../domain/usecases/send_location_usecase.dart";

part "location_event.dart";
part "location_state.dart";

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final RequestLocationPermission requestLocationPermission;
  final SendLocationUseCase sendLocationUseCase;

  LocationBloc({
    required this.getCurrentLocation,
    required this.requestLocationPermission,
    required this.sendLocationUseCase,
  }) : super(LocationInitial()) {
    on<RequestLocationPermissionEvent>(_onRequestLocationPermission);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<SendLocationToServerEvent>(_onSendLocationToServer);
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

  Future<void> _onSendLocationToServer(
    SendLocationToServerEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await sendLocationUseCase(event.latitude, event.longitude);
    result.fold(
      (failure) {
        print(" Error sending location to server");
        emit(LocationError("فشل في إرسال الموقع للسيرفر"));
      },
      (_) {
        print("✅ Location sent to server");
        final currentState = state;
        if (currentState is LocationLoaded) {
          emit(currentState);
        }
      },
    );
  }
}
