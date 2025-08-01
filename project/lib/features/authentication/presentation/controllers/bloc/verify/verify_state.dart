part of 'verify_bloc.dart';

abstract class VerifyState extends Equatable {
  

  @override
  List<Object> get props => [];
}

final class VerifyInitial extends VerifyState {}

final class VerifyLoading extends VerifyState {}

final class VerifySuccess extends VerifyState {
   VerifySuccess();

  @override
  List<Object> get props => [];
}

final class VerifyFailure extends VerifyState {
  final String error;
   VerifyFailure({required this.error});

  @override
  List<Object> get props => [error];
}
