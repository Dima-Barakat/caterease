import 'package:bloc/bloc.dart';
import 'package:caterease/features/authentication/domain/usecases/verify_email_use_case.dart';
import 'package:equatable/equatable.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final VerifyEmailUseCase useCase;

  VerifyBloc(this.useCase) : super(VerifyInitial()) {
    on<VerifySubmitted>((event, emit) async {
      emit(VerifyLoading());
      try {
        await useCase.verifyEmail(event.userId, event.otp);
        emit(VerifySuccess());
      } catch (e) {
        emit(VerifyFailure(error: e.toString()));
      }
    });
  }
}
