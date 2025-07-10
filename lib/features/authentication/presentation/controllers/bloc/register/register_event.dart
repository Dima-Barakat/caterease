part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String confirmationPassword;
  final String phone;
  final String gender;

  RegisterSubmitted(
      {required this.name,
      required this.email,
      required this.password,
      required this.confirmationPassword,
      required this.gender,
      required this.phone});

  @override
  List<Object> get props =>
      [name, email, password, confirmationPassword, phone, gender];
}
