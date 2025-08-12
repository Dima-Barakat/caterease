part of 'delivery_profile_bloc.dart';

sealed class DeliveryProfileState extends Equatable {
  const DeliveryProfileState();

  @override
  List<Object> get props => [];
}

final class DeliveryProfileInitial extends DeliveryProfileState {}

final class DeliveryProfileLoading extends DeliveryProfileState {}

final class DeliveryProfileLoaded extends DeliveryProfileState {}
