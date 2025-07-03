
part of "location_bloc.dart";

abstract class LocationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RequestLocationPermissionEvent extends LocationEvent {}

class GetCurrentLocationEvent extends LocationEvent {}


