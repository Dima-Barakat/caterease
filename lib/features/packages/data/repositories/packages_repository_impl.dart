import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/package.dart';
import '../../domain/entities/package_detail.dart';
import '../../domain/repositories/packages_repository.dart';
import '../datasources/packages_remote_data_source.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final PackagesRemoteDataSource remoteDataSource;

  PackagesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Package>>> getPackagesForBranch(
      int branchId) async {
    try {
      final remotePackages =
          await remoteDataSource.getPackagesForBranch(branchId);
      return Right(remotePackages);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PackageDetail>> getPackageDetail(int packageId) async {
    try {
      final packageDetail = await remoteDataSource.getPackageDetail(packageId);
      return Right(packageDetail);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
