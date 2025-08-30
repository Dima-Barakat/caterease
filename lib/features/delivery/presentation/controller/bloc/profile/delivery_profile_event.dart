part of 'delivery_profile_bloc.dart';

sealed class DeliveryProfileEvent extends Equatable {
  const DeliveryProfileEvent();

  @override
  List<Object> get props => [];
}

final class GetProfileEvent extends DeliveryProfileEvent {}
