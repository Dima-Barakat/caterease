part of 'delivery_profile_bloc.dart';

sealed class DeliveryProfileState extends Equatable {
  const DeliveryProfileState();

  @override
  List<Object> get props => [];
}

final class DeliveryProfileInitial extends DeliveryProfileState {}

final class DeliveryProfileLoading extends DeliveryProfileState {}

final class DeliveryProfileLoaded extends DeliveryProfileState {
  final DeliveryProfileModel profile;
  const DeliveryProfileLoaded(this.profile);
  @override
  List<Object> get props => [profile];
}

final class DeliveryProfileError extends DeliveryProfileState {
  final String message;
  const DeliveryProfileError(this.message);

  @override
  List<Object> get props => [message];
}
