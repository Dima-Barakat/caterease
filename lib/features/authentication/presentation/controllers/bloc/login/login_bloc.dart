import 'package:caterease/features/authentication/domain/usecases/login_user_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUserUseCase useCase;

  LoginBloc(this.useCase) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      final result = await useCase.login(
        event.email,
        event.password,
      );
      result.fold(
        (failure) {
          emit(LoginFailure(failure.toString()));
        },
        (authModel) {
          emit(LoginSuccess(authModel));
        },
      );
    });
  }
}
