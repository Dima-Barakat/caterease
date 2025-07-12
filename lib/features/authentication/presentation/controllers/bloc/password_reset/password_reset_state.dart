part of 'password_reset_bloc.dart';

sealed class PasswordResetState extends Equatable {
  @override
  List<Object> get props => [];
}

class PasswordResetInitial extends PasswordResetState {}

class PasswordResetLoading extends PasswordResetState {}

//! Email submission states
class PasswordResetEmailSent extends PasswordResetState {}

class PasswordResetEmailFailed extends PasswordResetState {
  final String error;

  PasswordResetEmailFailed(this.error);

  @override
  List<Object> get props => [error];
}

class PasswordResetEmailSuccess extends PasswordResetState {
  final String message;

  PasswordResetEmailSuccess(this.message);

  @override
  List<Object> get props => [message];
}

//! OTP verification states
class OtpVerificationSuccess extends PasswordResetState {}

class OtpVerificationFailed extends PasswordResetState {
  final String error;

  OtpVerificationFailed(this.error);

  @override
  List<Object> get props => [error];
}

class OtpVerificationLoading extends PasswordResetState {}

//! Password change states

class PasswordChangeSuccess extends PasswordResetState {
  PasswordChangeSuccess();

  @override
  List<Object> get props => [];
}

class PasswordChangeFailed extends PasswordResetState {
  final String error;

  PasswordChangeFailed(this.error);

  @override
  List<Object> get props => [error];
}

class PasswordChangeLoading extends PasswordResetState {}
