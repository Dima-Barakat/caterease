import 'package:caterease/features/profile/domain/usecases/get_profile_details_use_case.dart';
import 'package:caterease/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDetailsUseCase getProfileDetailsUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc(this.getProfileDetailsUseCase, this.updateProfileUseCase) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());

      try {
        final profile = await getProfileDetailsUseCase.getProfileDetails();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final updatedProfile = await updateProfileUseCase.updateProfileDetails(
          name: event.name,
          email: event.email,
          phone: event.phone,
          gender: event.gender,
          photo: event.photo,
        );

        emit(ProfileLoaded(updatedProfile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
