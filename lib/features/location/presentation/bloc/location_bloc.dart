import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:geolocator/geolocator.dart";
import "../../../../core/usecases/usecase.dart";
import "../../domain/usecases/get_current_location.dart";
import "../../domain/usecases/request_location_permission.dart";
import "../../domain/usecases/send_location_usecase.dart";
import "../../../../core/error/failures.dart"; // Import Failure

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
    print("📍 Event received: RequestLocationPermissionEvent");
    emit(LocationLoading());
    final result = await requestLocationPermission(NoParams());
    result.fold(
      (failure) {
        print(
            "Location Permission Request Failed: ${failure.message}"); // Debug print
        emit(LocationError(failure.message ??
            "خطأ غير معروف في إذن الموقع")); // Provide a default message
      },
      (granted) => granted
          ? emit(LocationPermissionGranted())
          : emit(LocationError(
              "تم رفض إذن الموقع")), // This message is correct for explicit denial
    );
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    print("📍 Event received: GetCurrentLocationEvent");

    emit(LocationLoading());
    final result = await getCurrentLocation(NoParams());
    result.fold(
      (failure) {
        print("Get Current Location Failed: ${failure.message}"); // Debug print
        emit(LocationError(failure.message ??
            "خطأ غير معروف في الحصول على الموقع")); // Provide a default message
      },
      (position) => emit(LocationLoaded(position)),
    );
  }

  Future<void> _onSendLocationToServer(
    SendLocationToServerEvent event,
    Emitter<LocationState> emit,
  ) async {
    print("📍 Event received: SendLocationToServerEvent");
    final result = await sendLocationUseCase(event.latitude, event.longitude);
    result.fold(
      (failure) {
        print(
            " Error sending location to server: ${failure.message}"); // Debug print
        emit(LocationError(failure.message ??
            "خطأ غير معروف في إرسال الموقع")); // Provide a default message
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
