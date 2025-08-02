part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  RegisterSuccess();

  @override
  List<Object> get props => [];
}

final class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure({required this.error});

  @override
  List<Object> get props => [error];
}
