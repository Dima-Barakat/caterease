import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_packages_for_branch.dart';
import 'packages_event.dart';
import 'packages_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  final GetPackagesForBranch getPackagesForBranch;

  PackagesBloc({required this.getPackagesForBranch})
      : super(PackagesInitial()) {
    on<GetPackagesForBranchEvent>((event, emit) async {
      emit(PackagesLoading());
      final failureOrPackages = await getPackagesForBranch(event.branchId);
      failureOrPackages.fold(
        (failure) =>
            emit(PackagesError(message: _mapFailureToMessage(failure))),
        (packages) => emit(PackagesLoaded(packages: packages)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;

      default:
        return 'Unexpected error';
    }
  }
}
