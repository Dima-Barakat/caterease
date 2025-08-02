import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_packages_for_branch.dart';
import '../../domain/usecases/get_package_detail.dart';
import 'packages_event.dart';
import 'packages_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  final GetPackagesForBranch getPackagesForBranch;
  final GetPackageDetail getPackageDetail;

  PackagesBloc({
    required this.getPackagesForBranch,
    required this.getPackageDetail,
  }) : super(PackagesInitial()) {
    on<GetPackagesForBranchEvent>((event, emit) async {
      emit(PackagesLoading());
      final failureOrPackages = await getPackagesForBranch(event.branchId);
      failureOrPackages.fold(
        (failure) =>
            emit(PackagesError(message: _mapFailureToMessage(failure))),
        (packages) => emit(PackagesLoaded(packages: packages)),
      );
    });

    on<GetPackageDetailEvent>((event, emit) async {
      emit(PackageDetailLoading());
      final failureOrPackageDetail = await getPackageDetail(event.packageId);
      failureOrPackageDetail.fold(
        (failure) =>
            emit(PackageDetailError(message: _mapFailureToMessage(failure))),
        (packageDetail) => emit(PackageDetailLoaded(packageDetail: packageDetail)),
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
