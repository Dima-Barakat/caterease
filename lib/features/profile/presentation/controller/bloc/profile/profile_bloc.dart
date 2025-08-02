import 'package:caterease/features/profile/domain/entities/user.dart';
import 'package:caterease/features/profile/domain/usecases/profile/get_profile_details_use_case.dart';
import 'package:caterease/features/profile/domain/usecases/profile/update_profile_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDetailsUseCase getProfileDetailsUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc(this.getProfileDetailsUseCase, this.updateProfileUseCase)
      : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());

      try {
        final result = await getProfileDetailsUseCase.getProfileDetails();
        result.fold(
          (failure) => emit(ProfileError(failure.toString())),
          (success) => emit(ProfileLoaded(success)),
        );
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final result = await updateProfileUseCase.updateProfileDetails(
          name: event.name,
          email: event.email,
          phone: event.phone,
          gender: event.gender,
          photo: event.photo,
        );

        result.fold(
          (failure) => emit(ProfileError(failure.toString())),
          (_) => emit(ProfileUpdated()),
        );
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
