part of 'password_reset_bloc.dart';

sealed class PasswordResetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//! Password Reset Request Events
class PasswordResetRequested extends PasswordResetEvent {
  final String email;

  PasswordResetRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordResetRequestSucceeded extends PasswordResetEvent {}

class PasswordResetRequestFailed extends PasswordResetEvent {
  final String error;

  PasswordResetRequestFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//! Password Reset Verification Events

class VerifyOtpEvent extends PasswordResetEvent {
  final String userId;
  final String otp;

  VerifyOtpEvent({required this.userId, required this.otp});

  @override
  List<Object> get props => [userId, otp];
}

class VerifyOtpSucceeded extends PasswordResetEvent {}

class VerifyOtpFailed extends PasswordResetEvent {
  final String error;

  VerifyOtpFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//! Change Password Events
class ChangePasswordEvent extends PasswordResetEvent {
  final String email;
  final String newPassword;
  final String passwordConfirmation;

  ChangePasswordEvent({
    required this.email,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [email, newPassword, passwordConfirmation];
}

class ChangePasswordSucceeded extends PasswordResetEvent {
  final String message;

  ChangePasswordSucceeded({required this.message});

  @override
  List<Object> get props => [message];
}
