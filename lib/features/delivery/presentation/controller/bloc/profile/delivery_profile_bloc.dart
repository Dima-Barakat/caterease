import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'delivery_profile_event.dart';
part 'delivery_profile_state.dart';

class DeliveryProfileBloc
    extends Bloc<DeliveryProfileEvent, DeliveryProfileState> {
  DeliveryProfileBloc() : super(DeliveryProfileInitial()) {
    on<GetProfileEvent>((event, emit) {});

    on<ChangeAvailabilityEvent>((event, emit) {});
  }
}
