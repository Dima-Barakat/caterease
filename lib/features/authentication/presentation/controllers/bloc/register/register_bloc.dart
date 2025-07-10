import 'package:bloc/bloc.dart';
import 'package:caterease/features/authentication/domain/usecases/register_user_use_case.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase useCase;

  RegisterBloc(this.useCase) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        await useCase.register(event.name, event.email, event.password,
            event.confirmationPassword, event.phone, event.gender);
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }
}
