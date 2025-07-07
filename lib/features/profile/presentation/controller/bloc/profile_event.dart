import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? photo;

  const UpdateProfile(
      {this.name, this.email, this.phone, this.gender, this.photo});
}
