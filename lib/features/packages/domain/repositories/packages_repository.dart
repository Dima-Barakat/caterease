import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/package.dart';
import '../entities/package_detail.dart';

abstract class PackagesRepository {
  Future<Either<Failure, List<Package>>> getPackagesForBranch(int branchId);
  Future<Either<Failure, PackageDetail>> getPackageDetail(int packageId);
}
