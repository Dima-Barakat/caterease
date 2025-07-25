part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? photo;

  const UpdateProfileEvent(
      {this.name, this.email, this.phone, this.gender, this.photo});

  @override
  List<Object?> get props => [name, email, phone, gender, photo];
}
