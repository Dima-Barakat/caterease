import 'package:caterease/features/delivery/data/models/delivery_profile_model.dart';
import 'package:caterease/features/delivery/domain/usecases/delivery_profile_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'delivery_profile_event.dart';
part 'delivery_profile_state.dart';

class DeliveryProfileBloc
    extends Bloc<DeliveryProfileEvent, DeliveryProfileState> {
  final DeliveryProfileUseCases useCases;

  DeliveryProfileBloc(this.useCases) : super(DeliveryProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(DeliveryProfileLoading());
      try {
        final result = await useCases.getProfile();
        result.fold(
          (failure) => emit(DeliveryProfileError(failure.toString())),
          (success) => emit(DeliveryProfileLoaded(success)),
        );
      } catch (e) {
        emit(DeliveryProfileError(e.toString()));
      }
    });
  }
}
