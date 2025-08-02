import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/package_detail.dart';
import '../repositories/packages_repository.dart';

class GetPackageDetail implements UseCase<PackageDetail, int> {
  final PackagesRepository repository;

  GetPackageDetail(this.repository);

  @override
  Future<Either<Failure, PackageDetail>> call(int packageId) async {
    return await repository.getPackageDetail(packageId);
  }
}

