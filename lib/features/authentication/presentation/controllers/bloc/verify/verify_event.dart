part of 'verify_bloc.dart';

abstract class VerifyEvent extends Equatable {
  const VerifyEvent();

  @override
  List<Object> get props => [];
}

final class VerifySubmitted extends VerifyEvent {
  final String userId;
  final String otp;

  const VerifySubmitted({required this.otp, required this.userId});

  @override
  List<Object> get props => [otp, userId];
}
