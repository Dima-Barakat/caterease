import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:caterease/features/authentication/domain/usecases/password_reset_use_case.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final PasswordResetUseCase useCase;

  PasswordResetBloc(this.useCase) : super(PasswordResetInitial()) {
    //! Step 1: Send Email
    on<PasswordResetRequestedEvent>((event, emit) async {
      emit(PasswordResetLoading());
      final result = await useCase.forgetPassword(email: event.email);

      result.fold(
        (failure) => emit(PasswordResetEmailFailed(failure.toString())),
        (_) => emit(PasswordResetEmailSent()),
      );
    });

    //! Step 2: Verify OTP
    on<VerifyOtpEvent>((event, emit) async {
      emit(PasswordResetLoading());
      final result =
          await useCase.verifyOtp(userId: event.userId, otp: event.otp);

      result.fold(
        (failure) => emit(OtpVerificationFailed(failure.toString())),
        (_) => emit(OtpVerificationSuccess()),
      );
    });

    //! Step 3: Change Password
    on<ChangePasswordEvent>((event, emit) async {
      emit(PasswordResetLoading());
      final result = await useCase.resetPassword(
        email: event.email,
        newPassword: event.newPassword,
        confirmPassword: event.passwordConfirmation,
      );
      result.fold(
        (failure) => emit(PasswordChangeFailed(failure.toString())),
        (message) => emit(PasswordChangeSuccess()),
      );
    });
  }
}
