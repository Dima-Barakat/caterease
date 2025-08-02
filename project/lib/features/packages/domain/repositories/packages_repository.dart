import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/package.dart';

abstract class PackagesRepository {
  Future<Either<Failure, List<Package>>> getPackagesForBranch(int branchId);
}
