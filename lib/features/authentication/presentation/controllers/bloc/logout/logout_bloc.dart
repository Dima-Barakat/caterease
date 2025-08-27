import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/authentication/domain/usecases/logout_use_case.dart';
import 'package:equatable/equatable.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase useCase;
  LogoutBloc(this.useCase) : super(LogoutInitial()) {
    on<LogoutSubmitted>((event, emit) async {
      emit(LogoutLoading());
      final result = await useCase.logout();
      result.fold(
        (failure) {
          emit(LogoutError(failure.toString()));
        },
        (_) {
          emit(LogoutLoaded());
        },
      );
    });
  }
}
