part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class RequestLocationPermissionEvent extends LocationEvent {}

class GetCurrentLocationEvent extends LocationEvent {}

class SendLocationToServerEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  const SendLocationToServerEvent(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}
