import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/package.dart';
import '../repositories/packages_repository.dart';

class GetPackagesForBranch {
  final PackagesRepository repository;

  GetPackagesForBranch(this.repository);

  Future<Either<Failure, List<Package>>> call(int branchId) async {
    return await repository.getPackagesForBranch(branchId);
  }
}
