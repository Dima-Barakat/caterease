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


//! Password Reset Verification Events

class VerifyOtpEvent extends PasswordResetEvent {
  final String userId;
  final String otp;

  VerifyOtpEvent({required this.userId, required this.otp});

  @override
  List<Object> get props => [userId, otp];
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