
import 'package:caterease/features/profile/domain/entities/address.dart';
import 'package:equatable/equatable.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressLoaded extends AddressState {
  final List<Address> addresses;

  const AddressLoaded(this.addresses);

  @override
  List<Object> get props => [addresses];
}

final class AddressCreated extends AddressState {}

final class AddressDeleted extends AddressState {}

final class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object> get props => [message];
}
